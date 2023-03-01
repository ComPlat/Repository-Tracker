module API
  class Base < Grape::API
    rescue_from ActiveRecord::RecordInvalid do |error|
      error! "#{error.record.model_name.name}: #{error.message}", 422
    end

    format :json

    # HINT: Needed to avoid CORS (Cross-Origin Resource Sharing) error.
    #       Swagger UI returns response code 0 if these lines aren't here.
    before do
      header["Access-Control-Allow-Origin"] = "*"
      header["Access-Control-Request-Method"] = "*"
    end

    mount API::V1::Trackings
    mount API::V1::TrackingItems

    add_swagger_documentation \
      host: swagger_host,
      security_definitions: {
        oAuth2PasswordFlow: {
          type: "oauth2",
          description: password_flow_description,
          flow: "password",
          tokenUrl: "/oauth/token"
        }
      },
      # HINT: Saves the access token so the user can access the data from Swagger UI.
      security: [
        {
          oAuth2PasswordFlow: []
        }
      ]

    private

    def swagger_host
      "#{ENV["APP_HOST"]}:#{ENV["APP_PORT"]}"
    end

    def client_id
      Doorkeeper::Application.find_by(name: "React SPA API Client")&.uid
    end

    def password_flow_description
      "Authorization using `OAuth2` password flow. Field `client_secret` **MUST** be empty!
\
client_id: #{client_id}"
    end
  end
end
