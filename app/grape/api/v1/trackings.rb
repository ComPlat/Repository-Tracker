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
          present Tracking.find(params[:id])
        end
      end

      desc "Create a tracking"
      params do
        requires :from, type: String, desc: "Tracking sender"
        requires :to, type: String, desc: "Tracking receiver"
        requires :status, type: String, desc: "Tracking status"
        requires :metadata, type: JSON
      end

      # FIXME: mb20221202 user_id have to use from authentication!
      post do
        tracking = Tracking.create({
          from: params[:from],
          to: params[:to],
          status: params[:status],
          metadata: params[:metadata],
          user_id: params[:user_id]
        })

        if tracking.valid?
          {id: tracking.id,
           from: tracking.from,
           to: tracking.to,
           status: tracking.status,
           metadata: tracking.metadata}
        else
          error!("Unprocessable Entity, #{tracking.errors.messages}", 422)
        end
      end
    end

    route :any, "*path" do
      error!("Not found", 404)
    end
  end
end
