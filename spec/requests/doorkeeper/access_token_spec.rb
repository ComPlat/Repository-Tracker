RSpec.describe Doorkeeper::AccessToken do
  include AuthHelper

  describe "POST /oauth/token" do
    let(:user) { build(:user, :with_required_attributes) }
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

    let(:expected_response) {
      {"access_token" => application.access_tokens.last&.token,
       "created_at" => application.access_tokens.last&.created_at&.time.to_i,
       "expires_in" => application.access_tokens.last&.expires_in,
       "refresh_token" => application.access_tokens.last&.refresh_token,
       "token_type" => application.access_tokens.last&.token_type}
    }

    before do
      register(user.name, user.email, user.password)
      login(user.email, user.password)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq expected_response }
  end
end
