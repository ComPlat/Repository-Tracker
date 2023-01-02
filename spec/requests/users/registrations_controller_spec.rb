describe Users::RegistrationsController do
  include AuthHelper

  describe "POST /users" do
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }
    let(:expected_user) { User.last }
    let(:expected_response) {
      {"created_at" => expected_user.created_at.iso8601(3),
       "email" => expected_user.email,
       "id" => expected_user.id,
       "name" => expected_user.name,
       "role" => expected_user.role,
       "updated_at" => expected_user.updated_at.iso8601(3)}
    }

    before {
      register
    }

    it { expect(response).to have_http_status(:ok) }
    it { expect(JSON.parse(response.body)).to match expected_response }
  end
end
