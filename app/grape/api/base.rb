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
      info: {
        title: "Repository-Tracker API"
      },
      doc_version: "0.1",
      host: "#{ENV["APP_HOST"]}:#{ENV["APP_PORT"]}",
      security_definitions: {
        oAuth2PasswordFlow: {
          type: "oauth2",
          description: "Authorization using `OAuth2` password flow. Field `client_secret` **MUST** be empty!
\
Use the client_id below:
\
client_id: **#{ENV["DOORKEEPER_CLIENT_ID"]}**",
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
  end
end
