describe Users::PasswordsController do
  include AuthHelper

  let(:user) { create(:user, :with_required_attributes_as_confirmed_user) }

  describe "POST /users/password" do
    context "when request for resetting password is submitted correctly" do
      it {
        reset_password(user.email)
        expect(response).to have_http_status :ok
      }

      it {
        reset_password(user.email)
        expect(ActionMailer::Base.deliveries.first).to be_a Mail::Message
      }

      it {
        reset_password(user.email)
        expect(ActionMailer::Base.deliveries.first.to).to eq [user.email]
      }

      it { expect { reset_password(user.email) }.to change(ActionMailer::Base.deliveries, :count).from(0).to(1) }
    end

    context "when email is blank and request for resetting password has failed" do
      before do
        reset_password("")
      end

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(response.parsed_body).to eq({"email" => ["can't be blank"]}) }
    end

    context "when email is not found and request for resetting password has failed" do
      before do
        reset_password("notfound@example.com")
      end

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(response.parsed_body).to eq({"email" => ["not found"]}) }
    end
  end

  describe "PUT /users/password" do
    let(:new_password) { "VerySecurePassword1!-" }

    context "when password has been changed successfully" do
      let(:expected_response) {
        {
          created_at: user.reload.created_at.iso8601(3),
          email: user.reload.email,
          id: user.reload.id,
          name: user.reload.name,
          role: user.reload.role,
          updated_at: user.reload.updated_at.iso8601(3)
        }
      }

      before do
        reset_password(user.email)
        email_body = Nokogiri::HTML(ActionMailer::Base.deliveries.first.body.raw_source)
        password_reset_link = email_body.at('a:contains("Change my password")')["href"]
        uri = URI.parse(password_reset_link)
        reset_password_token = CGI.parse(uri.query)["reset_password_token"].first
        change_password(new_password, new_password, reset_password_token)
      end

      it { expect(response).to have_http_status :ok }
      it { expect(response.parsed_body).to eq expected_response.as_json }
    end

    context "when password has NOT been changed successfully" do
      let(:invalid_reset_password_token) { "INVALIDACCESSTOKEN" }

      before do
        change_password(new_password, new_password, invalid_reset_password_token)
      end

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(response.parsed_body).to eq({"reset_password_token" => ["is invalid"]}) }
    end
  end
end
