# frozen_string_literal: true

module Authorization
  module Helper
    def initialize(grape_api) = @grape_api = grape_api

    private

    def not_found_error!(model_name, field_name, field_value)
      @grape_api.error!("Couldn't find #{model_name} with '#{field_name}'=#{field_value}", 404)
    end

    def not_authorized_error!(message) = @grape_api.error!(message, 401)

    def current_user = @current_user ||= User.find(doorkeeper_token.resource_owner_id)

    def doorkeeper_token = @doorkeeper_token ||= @grape_api.send(:doorkeeper_token)

    def params = @params ||= @grape_api.params
  end
end
