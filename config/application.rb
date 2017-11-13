require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

module IssueTracker
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true
    config.action_dispatch.rescue_responses['JWT::VerificationError'] = :unauthorized
  end
end
