# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render json: resource, status: :ok
    else
      render json: resource.errors.messages, status: :unprocessable_entity
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: resource, status: :ok
    else
      render json: resource.errors.messages, status: :unprocessable_entity
    end
  end
end
