# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "elemental_components"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    if Rails::VERSION::MAJOR < 7
      config.load_defaults 6.1
    else
      config.load_defaults 7.0
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    if Rails::VERSION::MAJOR < 6
      config.active_record.sqlite3.represent_boolean_as_integer = true
    end
  end
end
