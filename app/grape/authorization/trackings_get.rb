# frozen_string_literal: true

class Authorization::TrackingsGet
  def initialize(trackings_grape_api)
    @trackings_grape_api = trackings_grape_api
  end

  def all = @all ||= -> {
    case role
    when "admin"
      admin_or_super_records
    when "super"
      admin_or_super_records
    when "trackable_system_admin"
      trackable_system_admin_records
    when "user"
      user_records
    else
      no_records
    end
  }.call

  def one = @one ||= all.find(id)

  private

  def admin_or_super_records = Tracking.all

  def trackable_system_admin_records
    Tracking.where(from_trackable_system_id: trackable_system_ids)
      .or(Tracking.where(to_trackable_system_id: trackable_system_ids))
  end

  def user_records = Tracking.where(tracking_item: TrackingItem.where(user: current_user))

  def trackable_system_ids = @trackable_system_ids ||= TrackableSystem.where(user: current_user).ids

  def no_records = []

  def role = current_user.role

  def id = params["id"]

  def current_user = @current_user ||= User.find(doorkeeper_token.resource_owner_id)

  def doorkeeper_token = @trackings_grape_api.send(:doorkeeper_token)

  def params = @trackings_grape_api.params
end
