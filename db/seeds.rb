# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Initial application setup - do NOT remove!

if Rails.env.production? || Rails.env.development?
  Doorkeeper::Application.create!(name: "React SPA API Client", redirect_uri: "", uid: ENV["DOORKEEPER_CLIENT_ID"])
end

# Example seeds for development and testing

if Rails.env.development?
  password = "VerySecurePassword1!"
  confirmed_at = DateTime.now

  normal_user = User.create!(email: "user@example.com", password:, name: "User1", role: :user, confirmed_at:)
  User.create!(email: "super@example.com", password:, name: "Super1", role: :super, confirmed_at:)
  User.create!(email: "admin@example.com", password:, name: "Admin1", role: :admin, confirmed_at:)

  ts_radar4kit = TrackableSystem.create!(name: :radar4kit,
    user: User.create!(name: "radar4kit", email: "radar4@kit.de", password:, role: :trackable_system_admin, confirmed_at:))
  ts_radar4chem = TrackableSystem.create!(name: :radar4chem,
    user: User.create!(name: "radar4chem", email: "radar4@chem.de", password:, role: :trackable_system_admin, confirmed_at:))
  ts_chemotion_repository = TrackableSystem.create!(name: :chemotion_repository,
    user: User.create!(name: "chemotionrepository", email: "chemotion@reposito.ry", password:, role: :trackable_system_admin, confirmed_at:))
  ts_chemotion_electronic_laboratory_notebook = TrackableSystem.create!(name: :chemotion_electronic_laboratory_notebook,
    user: User.create!(name: "chemotioneln", email: "chemotion@repository.eln", password:, role: :trackable_system_admin, confirmed_at:))
  ts_nmrxiv = TrackableSystem.create!(name: :nmrxiv,
    user: User.create!(name: "nmrxiv", email: "nm@rx.iv", password:, role: :trackable_system_admin, confirmed_at:))

  tracking_item1 = TrackingItem.create!(name: "Tracking Item 1", user: normal_user)
  tracking_item2 = TrackingItem.create!(name: "Tracking Item 2", user: normal_user)
  tracking_item3 = TrackingItem.create!(name: "Tracking Item 3", user: normal_user)
  tracking_item4 = TrackingItem.create!(name: "Tracking Item 4", user: normal_user)
  tracking_item5 = TrackingItem.create!(name: "Tracking Item 5", user: normal_user)

  Tracking.create!(status: :draft, metadata: {data: "some new data"}, tracking_item: tracking_item1,
    from_trackable_system: ts_radar4kit, to_trackable_system: ts_radar4chem)
  Tracking.create!(status: :pending, metadata: {data: "some more new data"}, tracking_item: tracking_item2,
    from_trackable_system: ts_chemotion_electronic_laboratory_notebook, to_trackable_system: ts_chemotion_repository)
  Tracking.create!(status: :submitted, metadata: {data: "some other new data"}, tracking_item: tracking_item5,
    from_trackable_system: ts_chemotion_electronic_laboratory_notebook, to_trackable_system: ts_radar4chem)
  Tracking.create!(status: :draft, metadata: {data: "some extraordinary data"}, tracking_item: tracking_item3,
    from_trackable_system: ts_chemotion_repository, to_trackable_system: ts_radar4kit)
  Tracking.create!(status: :pending, metadata: {data: "some great data"}, tracking_item: tracking_item2,
    from_trackable_system: ts_chemotion_electronic_laboratory_notebook, to_trackable_system: ts_radar4kit)
  Tracking.create!(status: :submitted, metadata: {data: "some awesome data"}, tracking_item: tracking_item4,
    from_trackable_system: ts_nmrxiv, to_trackable_system: ts_radar4chem)
end
