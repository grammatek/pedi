# frozen_string_literal: true

class TiroTtsService < ApplicationService
  attr_reader :text

  BASE_URL = 'https://tts.tiro.is/v0'
  VOICE_INFO_URL = "#{BASE_URL}/voices"
  SPEAK_URL = "#{BASE_URL}/speech"

  @audio_dir = Rails.root.join('./app/assets/audios')
  @voice_list = nil

  # Declare accessors to the class instanc variables
  class << self
    attr_accessor :voice_list, :audio_dir
  end

  def self.update
    # Create audio directory
    FileUtils.mkdir_p @audio_dir
    # Remove old audio files from previous run
    old_audios = Dir.glob "#{@audio_dir}/tiro-*"
    FileUtils.rm_f(old_audios)

    # Connect to Tiro and retrieve current voice list
    @voice_list = HTTPX.get(VOICE_INFO_URL)
  end

  def initialize(entry, voice_name = 'Alfur')
    super()
    self.class.voice_list ||= nil

    # TODO: use a hash instead of lots of instance variables
    @engine = 'standard'
    @type = 'ssml'
    @voice_id = voice_name
    @sample_rate = '22050'
    @audio_format = 'mp3'
    @lang = 'is-IS'
    @entry = entry
    sampa = entry.sampa

    # annotate text as X-Sampa, example:
    # "<speak>
    #      <phoneme alphabet='x-sampa' ph='t a: G p j a r_0 t s O n'>Dagbjartsson</phoneme>.
    # </speak>"
    @text = "<speak><phoneme alphabet='x-sampa' ph='#{sampa}'>#{entry.word}</phoneme></speak>"
  end

  # Return generated audio file for text given in constructor
  def call
    TiroTtsService.update unless self.class.voice_list
    mp3_file = Rails.root.join("#{self.class.audio_dir}/tiro-#{@voice_id}-#{@entry.id}-#{@entry.updated_at}.mp3")
    # don't request a new file from polly if the same file already exists
    return mp3_file if File.exist?(mp3_file)

    params = {
      Engine: @engine,
      LanguageCode: @lang,
      OutputFormat: @audio_format,
      SampleRate: @sample_rate,
      Text: @text,
      TextType: @type,
      VoiceId: @voice_id
    }

    Rails.logger.debug "Tiro TTS: speak request: #{params}"
    response = HTTPX.post(SPEAK_URL, json: params)
    response.body.copy_to(mp3_file)
    if response.status != 200
      # play a buzzer sound
      FileUtils.rm_f(mp3_file)
      return Rails.root.join("#{self.class.audio_dir}/buzzer.wav")
    end
    mp3_file
  end

  # Return voice list by requesting from API
  def self.voices
    voice_list = HTTPX.get(VOICE_INFO_URL)
    obj = JSON.parse(voice_list, object_class: OpenStruct)
    obj.each_with_object([]) do |voice, arr|
      arr << voice.VoiceId
    end.sort
  end
end
