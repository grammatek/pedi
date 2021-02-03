class PollyService < ApplicationService

  attr_reader :text

  def self.update
    # Create audio directory
    @@audio_dir = Rails.root.join('./app/assets/audios')
    FileUtils::mkdir_p @@audio_dir
    # Remove old audio files from previous run
    old_audios = Dir.glob "#{@@audio_dir}/polly-*"
    FileUtils::rm_f(old_audios)
    # Connect to Polly
    access_key = Rails.application.credentials.amazon_polly_key
    access_secret = Rails.application.credentials.amazon_polly_secret
    region = 'eu-west-1'
    creds = Aws::Credentials.new(access_key, access_secret)
    @@polly = Aws::Polly::Client.new(region: region, credentials: creds)
  end

  def initialize(entry)
    @@polly ||= nil
    @type = 'ssml'
    @entry = entry

    # The Sampa set used for Amazon polly differs from the one used at Pedi.
    # Therefore, we need to replace our Sampas with the equivalent ones used
    # at Polly: http://developer.ivona.com/en/ttsresources/phonesets/phoneset-is.html
    polly_replace = {
        'p ' => 'b ',
        't ' => 'd ',
        'k ' => 'g ',
        'ou' => 'Ou',
        '9i' => '9Y',
    }
    sampa = entry.sampa
    polly_replace.each { |k,v| sampa.gsub!(k, v) }

    # annotate text as X-Sampa
    # "<speak>
    #      You say, <phoneme alphabet='x-sampa' ph='pI"kA:n'>pecan</phoneme>.
    #      I say, <phoneme alphabet='x-sampa' ph='"pi.k{n'>pecan</phoneme>.
    # </speak>"
    @text = "<speak><phoneme alphabet='x-sampa' ph='#{sampa}'>#{entry.word}</phoneme></speak>"
  end

  # Return generated audio file for text given in constructor
  def call
    PollyService.update if @@polly.nil?
    mp3_file = Rails.root.join("#{@@audio_dir}/polly-#{@entry.id}-#{@entry.updated_at}.mp3")
    # don't request a new file from polly if the same file already exists
    return mp3_file if File::exist?(mp3_file)
    params = {
        response_target: mp3_file,
        output_format: "mp3",
        text: @text,
        text_type: @type,
        voice_id: "Dora",
    }
    Rails.logger.debug "Polly: #{params}"
    @@polly.synthesize_speech(params) unless @@polly.nil?
    mp3_file
  end
end