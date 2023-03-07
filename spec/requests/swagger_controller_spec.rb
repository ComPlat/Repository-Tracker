describe SwaggerController do
  describe "GET /" do
    subject { response }

    before do
      get "/swagger"
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_rendered "swagger/index", "layouts/swagger" }
    it { expect(response.body).to include "<div id=\"swagger\" data-client-id=\"#{ENV["DOORKEEPER_CLIENT_ID"]}\"></div>" }
  end
end
