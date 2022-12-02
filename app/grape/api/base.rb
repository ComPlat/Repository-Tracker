module API
  class Base < Grape::API
    rescue_from ActiveRecord::RecordNotFound do |error|
      error! error.message, 404
    end

    format :json

    # HINT: Needed to avoid CORS (Cross-Origin Resource Sharing) error.
    #       Swagger UI returns response code 0 if these lines aren't here.
    before do
      header["Access-Control-Allow-Origin"] = "*"
      header["Access-Control-Request-Method"] = "*"
    end

    mount API::V1::Trackings
    add_swagger_documentation
  end
end
