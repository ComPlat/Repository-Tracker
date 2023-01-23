# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Initial application setup for development and production - do NOT remove!

if Rails.env.development? || Rails.env.production?
  Doorkeeper::Application.create!(name: "React SPA API Client", redirect_uri: "")
end

# Example seeds for development and testing

if Rails.env.development?
  normal_user = User.create!(email: "user@example.com",
    password: "password",
    name: "User1",
    role: User.roles[:user])
  super_user = User.create!(email: "super@example.com",
    password: "password",
    name: "Super1",
    role: User.roles[:super])
  admin_user = User.create!(email: "admin@example.com",
    password: "password",
    name: "Admin1",
    role: User.roles[:admin])

  password_trackable_systems = "VerySecurePassword1!"

  ts_radar4kit = TrackableSystem.create!(name: :radar4kit, user: User.create!(name: "radar4kit", email: "radar4@kit.de", password: password_trackable_systems, role: :trackable_system_admin))
  ts_radar4chem = TrackableSystem.create!(name: :radar4chem, user: User.create!(name: "radar4chem", email: "radar4@chem.de", password: password_trackable_systems, role: :trackable_system_admin))
  ts_chemotion_repository = TrackableSystem.create!(name: :chemotion_repository, user: User.create!(name: "chemotionrepository", email: "chemotion@reposito.ry", password: password_trackable_systems, role: :trackable_system_admin))
  ts_chemotion_electronic_laboratory_notebook = TrackableSystem.create!(name: :chemotion_electronic_laboratory_notebook, user: User.create!(name: "chemotioneln", email: "chemotion@repository.eln", password: password_trackable_systems, role: :trackable_system_admin))
  ts_nmrxiv = TrackableSystem.create!(name: :nmrxiv, user: User.create!(name: "nmrxiv", email: "nm@rx.iv", password: password_trackable_systems, role: :trackable_system_admin))

  tracking_item1 = TrackingItem.create!(name: "Tracking Item 1", user_id: normal_user.id)
  tracking_item2 = TrackingItem.create!(name: "Tracking Item 2", user_id: admin_user.id)
  tracking_item3 = TrackingItem.create!(name: "Tracking Item 3", user_id: normal_user.id)
  tracking_item4 = TrackingItem.create!(name: "Tracking Item 4", user_id: super_user.id)
  tracking_item5 = TrackingItem.create!(name: "Tracking Item 5", user_id: normal_user.id)

  Tracking.create!(status: :draft, metadata: {data: "some new data"}, tracking_item_id: tracking_item1.id,
    from_trackable_system_id: ts_radar4kit.id, to_trackable_system_id: ts_radar4chem.id)
  Tracking.create!(status: :pending, metadata: {data: "some more new data"}, tracking_item_id: tracking_item2.id,
    from_trackable_system_id: ts_chemotion_electronic_laboratory_notebook.id, to_trackable_system_id: ts_chemotion_repository.id)
  Tracking.create!(status: :submitted, metadata: {data: "some other new data"}, tracking_item_id: tracking_item5.id,
    from_trackable_system_id: ts_chemotion_electronic_laboratory_notebook.id, to_trackable_system_id: ts_radar4chem.id)
  Tracking.create!(status: :draft, metadata: {data: "some extraordinary data"}, tracking_item_id: tracking_item3.id,
    from_trackable_system_id: ts_chemotion_repository.id, to_trackable_system_id: ts_radar4kit.id)
  Tracking.create!(status: :pending, metadata: {data: "some great data"}, tracking_item_id: tracking_item2.id,
    from_trackable_system_id: ts_chemotion_electronic_laboratory_notebook.id, to_trackable_system_id: ts_radar4kit.id)
  Tracking.create!(status: :submitted, metadata: {data: "some awesome data"}, tracking_item_id: tracking_item4.id,
    from_trackable_system_id: ts_nmrxiv.id, to_trackable_system_id: ts_radar4chem.id)
end
