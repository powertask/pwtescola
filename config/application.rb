require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pwtcharges
  class Application < Rails::Application
    config.time_zone = 'Brasilia'
    config.i18n.default_locale = :"pt-BR"
  end
end
