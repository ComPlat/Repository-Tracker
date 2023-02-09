# frozen_string_literal: true

class Authorization::TrackingItemsGet
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
      []
    end
  }.call

  def one = @one ||= all.find_by!(name:)

  def tracking_ids = @tracking_ids ||= -> {
    case role
    when "admin"
      owned_tracking_ids
    when "super"
      owned_tracking_ids
    when "trackable_system_admin"
      trackable_system_admin_trackings.ids
    when "user"
      owned_tracking_ids
    else
      []
    end
  }.call

  private

  def owned_tracking_ids = @owned_tracking_ids ||= Tracking.where(tracking_item_id: all.ids).ids

  def admin_or_super_records = TrackingItem.all

  def trackable_system_admin_records = TrackingItem.where(id: trackable_system_admin_tracking_item_ids)

  def user_records = TrackingItem.where(user: current_user)

  def trackable_system_admin_tracking_item_ids = @trackable_system_admin_tracking_item_ids ||= trackable_system_admin_trackings
    .pluck(:tracking_item_id)

  def trackable_system_admin_trackings = @trackable_system_admin_trackings ||= Tracking
    .where(from_trackable_system_id: trackable_system_ids)
    .or(Tracking.where(to_trackable_system_id: trackable_system_ids))

  def trackable_system_ids = @trackable_system_ids ||= TrackableSystem.where(user: current_user).ids

  def role = current_user.role

  def name = params["name"]

  def current_user = @current_user ||= User.find(doorkeeper_token.resource_owner_id)

  def doorkeeper_token = @trackings_grape_api.send(:doorkeeper_token)

  def params = @trackings_grape_api.params
end
