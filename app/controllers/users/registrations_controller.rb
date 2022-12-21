# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params.except(:client_id))

    if resource.save
      render json: {id: resource.id,
                    email: resource.email,
                    access_token: access_token.token,
                    token_type: "bearer",
                    expires_in: access_token.expires_in,
                    refresh_token: access_token.refresh_token,
                    created_at: access_token.created_at.to_time.to_i}
    else
      render json: resource.errors.messages
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  private

  def application = @application ||= Doorkeeper::Application.find_by!(uid: sign_up_params[:client_id])

  def access_token = @access_token ||= Doorkeeper::AccessToken.create(
    expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
    resource_owner_id: resource.id,
    refresh_token: generate_refresh_token,
    application:
  )

  def generate_refresh_token
    loop do
      # generate a random token string and return it,
      # unless there is already another token with the same string
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end

  def sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :name, :client_id])
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end
