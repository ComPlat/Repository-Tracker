describe Users::RegistrationsController do
  include AuthHelper

  describe "POST /users" do
    let(:user) { build(:user, :with_required_attributes) }
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

    context "when valid registration request is being completed" do
      it { expect { register(user.name, user.email, user.password) }.to change(User, :count).from(0).to(1) }
    end

    context "when valid registration request has been completed" do
      let(:expected_response) {
        {"created_at" => User.last&.created_at&.iso8601(3),
         "email" => User.last&.email,
         "id" => User.last&.id,
         "name" => User.last&.name,
         "role" => User.last&.role,
         "updated_at" => User.last&.updated_at&.iso8601(3)}
      }

      before { register(user.name, user.email, user.password) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to eq expected_response }
      it { expect(response.parsed_body["role"]).to eq "user" }
    end

    context "when INVALID registration request is being completed" do
      let(:existing_user) { create(:user, :with_required_attributes) }

      before { existing_user }

      it { expect { register(existing_user.name, existing_user.email, existing_user.password) }.not_to change(User, :count).from(1) }
    end

    context "when INVALID registration request has been completed" do
      let(:existing_user) { create(:user, :with_required_attributes) }

      before {
        register(existing_user.name, existing_user.email, existing_user.password)
      }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.parsed_body).to eq "email" => ["has already been taken"] }
    end
  end
end
