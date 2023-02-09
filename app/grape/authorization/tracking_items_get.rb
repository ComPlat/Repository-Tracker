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
      no_records
    end
  }.call

  def one = @one ||= all.find_by!(name:)

  # TODO: Write specs for this!
  def tracking_ids = @tracking_ids ||= trackings.ids

  private

  def admin_or_super_records = TrackingItem.all

  def trackable_system_admin_records = TrackingItem.where(id: tracking_item_ids)

  def user_records = TrackingItem.where(user: current_user)

  def tracking_item_ids = @tracking_item_ids ||= trackings.pluck(:tracking_item_id)

  def trackings = @trackings ||= Tracking.where(from_trackable_system_id: trackable_system_ids)
    .or(Tracking.where(to_trackable_system_id: trackable_system_ids))

  def trackable_system_ids = @trackable_system_ids ||= TrackableSystem.where(user: current_user).ids

  def no_records = []

  def role = current_user.role

  def name = params["name"]

  def current_user = @current_user ||= User.find(doorkeeper_token.resource_owner_id)

  def doorkeeper_token = @trackings_grape_api.send(:doorkeeper_token)

  def params = @trackings_grape_api.params
end
