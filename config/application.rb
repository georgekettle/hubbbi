require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hubbbi
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework nil
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # to use routes for error pages (404/500...)
    config.exceptions_app = self.routes

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_token => ENV["POSTMARK_API_TOKEN"] }
  end
end
