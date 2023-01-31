describe Users::RegistrationsController do
  include AuthHelper

  describe "POST /users" do
    let(:user) { build(:user, :with_required_attributes_as_user) }
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

# describe Users::RegistrationsController do
#   include AuthHelper
#
#   describe "POST /users" do
#     let(:application) { create(:doorkeeper_application, :with_required_attributes) }
#     let(:expected_user) { User.last }
#
#     it {
#       register
#       expect(response).to have_http_status(:ok)
#     }
#
#     it {
#       register
#       expect(response.parsed_body.keys).to eq %w[id name role email created_at updated_at]
#     }
#
#     it {
#       register
#       expect(response.parsed_body["id"]).to eq expected_user.id
#     }
#
#     it {
#       register
#       expect(response.parsed_body["name"]).to eq expected_user.name
#     }
#
#     it {
#       register
#       expect(response.parsed_body["role"]).to eq expected_user.role
#     }
#
#     it {
#       register
#       expect(response.parsed_body["email"]).to eq expected_user.email
#     }
#
#     it {
#       register
#       expect(response.parsed_body["created_at"]).to eq expected_user.created_at.iso8601(3)
#     }
#
#     it {
#       register
#       expect(response.parsed_body["updated_at"]).to eq expected_user.updated_at.iso8601(3)
#     }
#
#     it { expect { register }.to change(User, :count).from(0).to(1) }
#
#     it {
#       register
#       expect(expected_user.confirmed_at).to be_nil
#     }
#
#     it {
#       register
#       expect(expected_user.unconfirmed_email).to be_nil
#     }
#
#     # it {
#     #   register
#     #   expect(User.last.attributes).to eq({"confirmation_sent_at" => 2023-01-31 16:49:43.954861000 0000,
#     #                                       "confirmation_token" => "DAbDEnjfwS4-xMPPkuzh",
#     #                                       "confirmed_at" => nil,
#     #                                       "created_at" => 2023-01-31 16:49:43.954813000 0000,
#     #                                       "email" => "tobias.vetter@cleanercode.de",
#     #                                       "encrypted_password" => "$2a$04$jmFky0Y7sMfbBJ4h2sruM.aTZBppHDu3.VjGC23knbJeRNP28LJVu",
#     #                                       "id" => 10,
#     #                                       "name" => "name",
#     #                                       "remember_created_at" => nil,
#     #                                       "reset_password_sent_at" => nil,
#     #                                       "reset_password_token" => nil,
#     #                                       "role" => "user",
#     #                                       "unconfirmed_email" => nil,
#     #                                       "updated_at" => 2023-01-31 16:49:43.954813000 +0000,})
#     # }
#   end
# end
