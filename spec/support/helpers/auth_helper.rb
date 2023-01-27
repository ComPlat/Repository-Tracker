module AuthHelper
  def register(name, email, password)
    @register ||= -> {
      post "/users",
        params: {user: {name:, email:, password:}}, as: :json
      response.parsed_body["access_token"]
    }.call
  end

  def login(email, password)
    post "/oauth/token",
      params: {
        grant_type: "password",
        email:,
        password:,
        client_id: application.uid
      }, as: :json
  end

  def revoke(email, password)
    post "/oauth/revoke",
      headers: {Authorization: "\"username\": #{email}, \"password\": #{password}"},
      params: {client_id: application.uid}, as: :json
  end

  def refresh_token
    post "/oauth/token",
      params: {
        grant_type: "refresh_token",
        refresh_token: application.access_tokens.last.refresh_token,
        client_id: application.uid
      }, as: :json
    response.parsed_body["refresh_token"]
  end

  def create_entry(name)
    @create_entry ||= -> {
      post "/api/v1/trackings/",
        params: build_request(:tracking_request, :create)
          .merge(access_token: application.access_tokens.last.token, tracking_item_owner_name: name)

      response.parsed_body["id"]
    }.call
  end
end
