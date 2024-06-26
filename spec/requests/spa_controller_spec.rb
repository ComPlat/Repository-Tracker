describe SpaController do
  describe "GET /" do
    subject { response }

    before do
      get "/"
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_rendered "spa/index", "layouts/spa" }
    it { expect(response.body).to include "<div id=\"spa\" data-client-id=\"#{ENV["DOORKEEPER_CLIENT_ID"]}\"></div>" }
  end
end
