describe Users::RegistrationsController do
  include AuthHelper

  describe "POST /users" do
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

    context "when valid registration request is being completed" do
      it { expect { register }.to change(User, :count).from(0).to(1) }
    end

    context "when valid registration request has been completed" do
      let(:expected_user) { User.last }
      let(:expected_response) {
        {"created_at" => expected_user&.created_at&.iso8601(3),
         "email" => expected_user&.email,
         "id" => expected_user&.id,
         "name" => expected_user&.name,
         "role" => expected_user&.role,
         "updated_at" => expected_user&.updated_at&.iso8601(3)}
      }

      before { register }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to eq expected_response }
      it { expect(response.parsed_body["role"]).to eq "user" }
    end

    context "when INVALID registration request is being completed" do
      before { create(:user, :with_required_attributes, email: AuthHelper::EMAIL) }

      it { expect { register }.not_to change(User, :count).from(1) }
    end

    context "when INVALID registration request has been completed" do
      before {
        create(:user, :with_required_attributes, email: AuthHelper::EMAIL)
        register
      }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.parsed_body).to eq "email" => ["has already been taken"] }
    end
  end
end
