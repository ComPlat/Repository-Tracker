# frozen_string_literal: true

describe Users::RegistrationsController do
  let(:oauth_app) { create(:doorkeeper_application, :with_required_attributes, :with_required_dependencies) }
  let(:expected_response) {
    {"access_token" => Doorkeeper::AccessToken.last.token,
     "created_at" => User.last.created_at.time.to_i,
     "email" => "tobias.vetter@cleanercode.de",
     "expires_in" => 7200,
     "id" => User.last.id,
     "refresh_token" => be_a(String),
     "token_type" => "bearer"}
  }

  before {
    post "/users",
      headers: {Accept: "application/json", "Content-Type": "application/json"},
      params: {user:
                 {name: "name",
                  role: "user",
                  email: "tobias.vetter@cleanercode.de",
                  password: "verysecure",
                  client_id: oauth_app.uid}}, as: :json
  }

  it { expect(response).to have_http_status(:ok) }
  it { expect(JSON.parse(response.body)).to match expected_response }
end
