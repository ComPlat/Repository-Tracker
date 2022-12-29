describe Users::RegistrationsController do
  include AuthHelper

  describe "POST /users" do
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }
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
end
