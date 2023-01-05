# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Doorkeeper::Application.count.zero?
  Doorkeeper::Application.create!(name: "React SPA API Client", redirect_uri: "")
end

# Example seeds for development and testing - REMOVE in production environment!

User.create(email: "user@example.com",
  password: "password",
  name: "User1",
  role: User.roles[:user])
User.create(email: "admin@example.com",
  password: "password",
  name: "Admin1",
  role: User.roles[:admin])
User.create(email: "super@example.com",
  password: "password",
  name: "Super1",
  role: User.roles[:super])

TrackableSystem.create(name: :radar4kit)
TrackableSystem.create(name: :radar4chem)
TrackableSystem.create(name: :chemotion_repository)
TrackableSystem.create(name: :chemotion_electronic_laboratory_notebook)
TrackableSystem.create(name: :nmrxiv)

TrackingItem.create(name: "Tracking Item 1", user_id: 1)
TrackingItem.create(name: "Tracking Item 2", user_id: 2)
TrackingItem.create(name: "Tracking Item 3", user_id: 1)
TrackingItem.create(name: "Tracking Item 4", user_id: 3)
TrackingItem.create(name: "Tracking Item 5", user_id: 1)

Tracking.create(status: :draft, metadata: {data: "some new data"}, tracking_item_id: 1,
  from_trackable_system_id: 1, to_trackable_system_id: 2)
Tracking.create(status: :pending, metadata: {data: "some more new data"}, tracking_item_id: 2,
  from_trackable_system_id: 4, to_trackable_system_id: 3)
Tracking.create(status: :submitted, metadata: {data: "some other new data"}, tracking_item_id: 5,
  from_trackable_system_id: 4, to_trackable_system_id: 2)
Tracking.create(status: :draft, metadata: {data: "some extraordinary data"}, tracking_item_id: 3,
  from_trackable_system_id: 3, to_trackable_system_id: 1)
Tracking.create(status: :pending, metadata: {data: "some great data"}, tracking_item_id: 2,
  from_trackable_system_id: 4, to_trackable_system_id: 1)
Tracking.create(status: :submitted, metadata: {data: "some awesome data"}, tracking_item_id: 4,
  from_trackable_system_id: 5, to_trackable_system_id: 2)
