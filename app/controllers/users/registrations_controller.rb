# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource(sign_up_params.merge(role: :user)) # HINT: Every higher role needs manual upgrade by an admin.
    resource.save

    if resource.persisted?
      expire_data_after_sign_in!
      render json: resource, status: :ok
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: resource.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end
