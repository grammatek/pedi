# frozen_string_literal: true

class TtsService < ApplicationService
  def initialize(entry, voice_name = 'Alfur')
    super()
    @entry = entry
    @voice_id = voice_name
  end

  # Return generated audio file for text given in constructor
  def call
    case Rails.configuration.tts_backend
    when :tiro
      TiroTtsService.call(@entry, @voice_id)
    when :polly
      PollyService.call(@entry, @voice_id)
    else
      Rails.logger.warn('Unknown configuration given for config.tts_backend')
    end
  end

  # Return voice list by requesting from API
  def self.voices
    case Rails.configuration.tts_backend
    when :tiro
      TiroTtsService.voices
    when :polly
      %w[Dora Karl]
    else
      Rails.logger.warn('Unknown configuration given for config.tts_backend')
      []
    end
  end
end
