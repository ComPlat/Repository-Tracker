# frozen_string_literal: true

class Authorization::TrackingsPost
  # TODO: This needs a unit spec.

  MSG_TRACKABLE_SYSTEM_ADMIN = "Only Trackable System Admins are allowed to create Tracking records."
  MSG_TRACKABLE_SYSTEM_OWNER = "Only Trackable System Admin of either source (from) or target (to) Trackable System is allowed to create Tracking record."
  STATUS = 401

  def initialize(trackings_grape_api)
    @trackings_grape_api = trackings_grape_api
  end

  def authorized?
    return true if admin?

    error! MSG_TRACKABLE_SYSTEM_ADMIN, STATUS unless trackable_system_admin?
    error! MSG_TRACKABLE_SYSTEM_OWNER, STATUS unless trackable_system_owner?

    true
  end

  private

  def admin? = @admin ||= current_user.admin?

  def error!(message, status) = @trackings_grape_api.error!(message, status)

  def trackable_system_admin? = @trackable_system_admin ||= current_user.trackable_system_admin?

  def trackable_system_owner? = @trackable_system_owner ||= TrackableSystem
    .where(name:)
    .pluck(:user_id)
    .include?(current_user.id)

  def name = @name ||= [params["from_trackable_system_name"], params["to_trackable_system_name"]]

  def params = @params ||= @trackings_grape_api.params

  def current_user = @current_user ||= User.find(doorkeeper_token.resource_owner_id)

  def doorkeeper_token = @doorkeeper_token ||= @trackings_grape_api.send(:doorkeeper_token)
end
