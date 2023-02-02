describe Users::ConfirmationsController do
  include AuthHelper

  describe "GET /users/confirmation" do
    let(:built_user) { build(:user, :with_required_attributes_as_user) }
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

    context "when confirmation is successful" do
      let(:expected_user) { User.find_by(email: built_user.email) }

      before {
        register(built_user.name, built_user.email, built_user.password)
        get "/users/confirmation", params: {confirmation_token: expected_user.confirmation_token}
      }

      it { expect(response.body).to include "/#confirmation_successful" }
      it { expect(response).to have_http_status :found }

      it { expect(User.first.confirmed_at).to be_a ActiveSupport::TimeWithZone }
      it { expect(User.first.confirmed?).to be true }
    end

    context "when confirmation has been failed" do
      before {
        register(built_user.name, built_user.email, built_user.password)
        get "/users/confirmation", params: {confirmation_token: "notavalidconfirmationtoken"}
      }

      it { expect(response.body).to include "/#confirmation_error?errors=" }
      it { expect(response).to have_http_status :found }

      it { expect(User.first.confirmed_at).to be_nil }
      it { expect(User.first.confirmed?).to be false }
    end
  end
end
