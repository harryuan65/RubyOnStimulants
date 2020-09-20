require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HarrysWorkspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app','api','*')]
    config.autoload_paths += Dir[Rails.root.join('app','renderers','*')]
    config.i18n.load_path += Dir[Rails.root.join('config','locales','*.yml')]
    config.i18n.default_locale = :en
    config.time_zone = 'Taipei'
    config.active_record.default_timezone = :local
    I18n.default_locale = :en
    config.generators.javascript_engine = :js # disable coffee
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
