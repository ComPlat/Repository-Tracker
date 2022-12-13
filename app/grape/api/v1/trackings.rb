module API::V1
  class Trackings < Grape::API
    version "v1", using: :path

    namespace :trackings do
      desc "Return list of trackings"
      get do
        # TODO: mb20221202 return only the user associated trackings
        present Tracking.all
      end

      desc "Return a tracking"
      params do
        requires :id, type: Integer, desc: "Tracking ID"
      end
      route_param :id, type: Integer do
        get do
          present Tracking.find params[:id]
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
        present TrackingBuilder.new(params).create!, with: API::Entities::Tracking
      end
    end

    route :any, "*path" do
      error!("Not found", 404)
    end
  end
end
