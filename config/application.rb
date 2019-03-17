require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Moremmn
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.i18n.load_path += Dir["#{Rails.root.to_s}/config/locales/**/*.{rb,yml}"]
    config.i18n.default_locale = 'pt-BR'
    config.i18n.available_locales = [:en, 'pt-BR', :es]
    config.i18n.enforce_available_locales = false

    config.time_zone = 'Brasilia'

    config.action_controller.permit_all_parameters = true

    config.middleware.use Rack::Attack
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/*', headers: :any, methods: [:get, :post, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
