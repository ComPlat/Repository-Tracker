class API::V1::Trackings < Grape::API
  version "v1", using: :path

  helpers Doorkeeper::Grape::Helpers

  before { doorkeeper_authorize! }

  namespace :trackings do
    desc "Return list of trackings"
    get do
      trackings_get_authorization = Authorization::TrackingsGet.new self
      present trackings_get_authorization.all, with: API::Entities::Tracking
    end

    desc "Return a tracking" # TODO: Also provide for tracker number
    params do
      requires :id, type: Integer, desc: "Tracking ID"
    end
    route_param :id, type: Integer do
      get do
        trackings_get_authorization = Authorization::TrackingsGet.new self
        present trackings_get_authorization.one, with: API::Entities::Tracking
      end
    end

    desc "Create a tracking"
    params do
      requires :status, type: String, desc: "Tracking status"
      requires :metadata, type: JSON, desc: "Tracking metadata"
      requires :tracking_item_name, type: String, desc: "Tracking unique identifier"
      requires :from_trackable_system_name, type: String, desc: "Tracking source"
      requires :to_trackable_system_name, type: String, desc: "Tracking receiver"
    end

    # TODO: mb20221202 user_id have to use from authentication!
    post do
      trackings_post_authorization = Authorization::TrackingsPost.new self
      present TrackingBuilder.new(params).create!, with: API::Entities::Tracking if trackings_post_authorization.authorized?
    end
  end

  route :any, "*path" do
    error! "Not found", 404
  end
end
