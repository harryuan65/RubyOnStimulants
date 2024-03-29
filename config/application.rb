require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ActiveMine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :classic
    config.eager_load_paths += %W[#{config.root}/lib]
    config.i18n.load_path += Dir[Rails.root.join('config','locales','*.yml')]
    # config.autoload_paths += Dir[Rails.root.join('app', 'services', '{**}')]
    config.i18n.default_locale = :en
    config.time_zone = 'Asia/Taipei'
    config.active_record.default_timezone = :local
    config.i18n.fallbacks = true
    I18n.available_locales = [:en, :"zh-TW"]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
