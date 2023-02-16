# frozen_string_literal: true

class Authorization::TrackingsPost
  include Authorization::Helper

  MSG_TRACKABLE_SYSTEM_ADMIN = "Only Trackable System Admins are allowed to create Tracking records."
  MSG_TRACKABLE_SYSTEM_OWNER = "Only Trackable System Admin of either source (from) or target (to) Trackable System is allowed to create Tracking record."

  def authorized?
    return not_authorized_error! MSG_TRACKABLE_SYSTEM_ADMIN unless trackable_system_admin?
    return not_authorized_error! MSG_TRACKABLE_SYSTEM_OWNER unless trackable_system_owner?

    true
  end

  private

  def trackable_system_admin? = @trackable_system_admin ||= current_user.trackable_system_admin?

  def trackable_system_owner? = @trackable_system_owner ||= TrackableSystem
    .where(name:)
    .pluck(:user_id)
    .include?(current_user.id)

  def name = @name ||= [params["from_trackable_system_name"], params["to_trackable_system_name"]]
end
