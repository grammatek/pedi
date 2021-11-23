# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pedi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #

    # Configure allowed locales
    config.i18n.available_locales = %i[en is]
    config.i18n.default_locale = :is

    # Configure TTS backend. Possible values are :tiro (recommended), or :polly (Amazon Polly).
    # The former provides 2 Icelandic neural voices and 2 unit selection voices, whereas the latter
    # provides only 2 unit selection voices
    config.tts_backend = :tiro
  end
end
