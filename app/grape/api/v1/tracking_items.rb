class API::V1::TrackingItems < Grape::API
  version "v1", using: :path

  helpers Doorkeeper::Grape::Helpers

  before { doorkeeper_authorize! }

  namespace :tracking_items do
    desc "Return list of tracking_items"
    get do
      authorization = Authorization::TrackingItemsGet.new self
      present authorization.all, with: API::Entities::Tracking
    end

    desc "Return a tracking_item"
    params do
      requires :name, type: String, desc: "TrackingItem name"
    end
    route_param :name, type: String do
      get do
        authorization = Authorization::TrackingItemsGet.new self
        present authorization.one, with: API::Entities::Tracking
      end
    end
  end

  route :any, "*path" do
    error! "Not found", 404
  end
end
