module AuthHelper
  def register
    @register ||= -> {
      post "/users",
        params: {user: {name: "name", role: "user", email: "tobias.vetter@cleanercode.de", password: "verysecure", client_id: application.uid}}, as: :json
      response.parsed_body["access_token"]
    }.call
  end

  def login
    post "/oauth/token",
      params: {
        grant_type: "password",
        email: "tobias.vetter@cleanercode.de",
        password: "verysecure",
        client_id: application.uid
      }, as: :json
  end

  def revoke
    post "/oauth/revoke",
      headers: {Authorization: '"username": "tobias.vetter@cleanercode.de", "password": "verysecure"'},
      params: {
        client_id: application.uid
      }, as: :json
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

  def create_entry
    @create_entry ||= -> {
      post "/api/v1/trackings/", params: build_request(:tracking_request, :create).merge(access_token: application.access_tokens.last.token)

      response.parsed_body["id"]
    }.call
  end
end
