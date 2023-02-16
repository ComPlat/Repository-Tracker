# frozen_string_literal: true

class Authorization::TrackingsGet
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
      no_records
    end
  }.call

  def one
    @one ||= all.find(id)
  rescue ActiveRecord::RecordNotFound => error
    not_found_error!(error.model, "id", id)
  end

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
end
