describe Users::RegistrationsController do
  include AuthHelper

  describe "POST /users" do
    let(:built_user) { build(:user, :with_required_attributes_as_user) }
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

    context "when valid registration request is being completed" do
      it { expect { register(built_user.name, built_user.email, built_user.password) }.to change(User, :count).from(0).to(1) }
    end

    context "when valid registration request has been completed" do
      let(:expected_user) { User.find_by(email: built_user.email) }

      let(:expected_response) {
        {"created_at" => expected_user&.created_at&.iso8601(3),
         "email" => expected_user&.email,
         "id" => expected_user&.id,
         "name" => expected_user&.name,
         "role" => expected_user&.role,
         "updated_at" => expected_user&.updated_at&.iso8601(3)}
      }

      context "when request has been done" do
        before { register(built_user.name, built_user.email, built_user.password) }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.parsed_body.keys).to eq %w[id name role email created_at updated_at] }
        it { expect(response.parsed_body["id"]).to eq expected_user.id }
        it { expect(response.parsed_body["name"]).to eq built_user.name }
        it { expect(response.parsed_body["role"]).to eq built_user.role }
        it { expect(response.parsed_body["email"]).to eq built_user.email }
        it { expect(response.parsed_body["name"]).to eq expected_user.name }
        it { expect(response.parsed_body["role"]).to eq expected_user.role }
        it { expect(response.parsed_body["email"]).to eq expected_user.email }
        it { expect(response.parsed_body["created_at"]).to eq expected_user.created_at.iso8601(3) }
        it { expect(response.parsed_body["updated_at"]).to eq expected_user.updated_at.iso8601(3) }

        it {
          expect(expected_user&.attributes&.keys)
            .to eq %w[id name role email encrypted_password reset_password_token reset_password_sent_at
              remember_created_at confirmation_token confirmed_at confirmation_sent_at unconfirmed_email
              created_at updated_at]
        }

        it { expect(expected_user.encrypted_password).to be_a String }
        it { expect(expected_user.reset_password_token).to be_nil }
        it { expect(expected_user.reset_password_sent_at).to be_nil }
        it { expect(expected_user.remember_created_at).to be_nil }
        it { expect(expected_user.confirmation_token).to be_a String }
        it { expect(expected_user.confirmation_sent_at).to be_within(0.01).of(expected_user.created_at) }
        it { expect(expected_user.unconfirmed_email).to be_nil }
        it { expect(expected_user.confirmed_at).to be_nil }
        it { expect(expected_user.confirmed?).to be false }
        it { expect(ActionMailer::Base.deliveries.first).to be_a Mail::Message }
        it { expect(ActionMailer::Base.deliveries.first.to).to eq [built_user.email] }
        it { expect(ActionMailer::Base.deliveries.first.body).to include built_user.email, expected_user.confirmation_token }
      end

      it { expect { register(built_user.name, built_user.email, built_user.password) }.to change(User, :count).from(0).to(1) }
      it { expect { register(built_user.name, built_user.email, built_user.password) }.to change { ActionMailer::Base.deliveries.count }.from(0).to(1) }
    end

    context "when INVALID registration request is being completed" do
      let(:existing_user) { create(:user, :with_required_attributes_as_user) }

      before { existing_user }

      it { expect { register(existing_user.name, existing_user.email, existing_user.password) }.not_to change(User, :count).from(1) }
    end

    context "when INVALID registration request has been completed" do
      let(:existing_user) { create(:user, :with_required_attributes_as_user) }

      before {
        register(existing_user.name, existing_user.email, existing_user.password)
      }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.parsed_body).to eq "email" => ["has already been taken"] }
    end
  end
end
