# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to "/spa/confirmation_successful"
    else
      redirect_to "/spa/confirmation_error?#{model_name}=#{error_type}", allow_other_host: true
    end
  end

  private

  def model_name
    resource.errors.first.attribute.to_s
  end

  def error_type
    resource.errors.first.type.to_s
  end
end
