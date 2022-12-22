describe Users::RegistrationsController do
  include AuthHelper

  let(:application) { create(:doorkeeper_application, :with_required_attributes) }

  describe "POST /users" do
    let(:expected_response) {
      {"created_at" => User.last.created_at.iso8601(3),
       "email" => User.last.email,
       "id" => User.last.id,
       "name" => User.last.name,
       "role" => User.last.role,
       "updated_at" => User.last.updated_at.iso8601(3)}
    }

    before {
      register
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(JSON.parse(response.body)).to match expected_response }
  end

  describe "POST /oauth/token" do
    let(:expected_response) {
      {"access_token" => application.access_tokens.last&.token,
       "created_at" => application.access_tokens.last&.created_at&.time.to_i,
       "expires_in" => application.access_tokens.last&.expires_in,
       "refresh_token" => application.access_tokens.last&.refresh_token,
       "token_type" => application.access_tokens.last&.token_type}
    }

    before do
      register
      login
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq expected_response }
  end
end
