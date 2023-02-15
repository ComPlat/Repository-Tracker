# frozen_string_literal: true

class Authorization::TrackingItemsGet
  include Authorization::Helper

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

  def one
    @one ||= all.find_by!(name:)
  rescue ActiveRecord::RecordNotFound => error
    not_found_error!(error.model, "name", name)
  end

  def tracking_ids = @tracking_ids ||= -> {
    case role
    when "admin"
      owned_tracking_ids
    when "super"
      owned_tracking_ids
    when "trackable_system_admin"
      trackable_system_admin_trackings_ids
    when "user"
      owned_tracking_ids
    else
      []
    end
  }.call

  private

  def trackable_system_admin_trackings_ids = @trackable_system_admin_trackings_ids ||= trackable_system_admin_trackings.ids

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
end
