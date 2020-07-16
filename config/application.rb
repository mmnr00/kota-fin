require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KidcareTaskaV3
  class Application < Rails::Application
    config.load_defaults 5.2
    config.assets.paths << Rails.root.join("vendor","assets", "fonts")
    config.time_zone = 'Singapore'
    config.active_record.default_timezone = :local
    config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'ALLOWALL'
    }
    #config.assets.paths << File.join(Rails.root, '/vendor/webarch_core')
    #config.assets.paths << File.join(Rails.root, '/vendor/agency')
    #config.assets.enabled = true
    #config.serve_static_assets = true
    #config.force_ssl = true
    # Initialize configuration defaults for originally generated Rails version.
    

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

