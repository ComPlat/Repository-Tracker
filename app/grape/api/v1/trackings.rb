module API::V1
  class Trackings < Grape::API
    version "v1", using: :path

    args = [{ "tracking1" => "My first tracking" }, { "tracking2" => "My second tracking" }]

    namespace :trackings do
      desc "Return list of trackings"
      get do
        present args
      end

      desc "Return a tracking"
      params do
        requires :id, type: Integer, desc: "Tracking ID"
      end
      route_param :id, type: Integer do
        get do
          present args[params[:id]]
        end
      end

      desc "Create a tracking"
      params do
        requires :title, type: String, desc: "Tracking title"
        requires :content, type: String, desc: "Tracking content"
      end
      post do
        args.push({ params[:title] => params[:content] })
      end
    end

    route :any, "*path" do
      error!("Not found", 404)
    end
  end
end
