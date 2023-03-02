describe SpaController do
  describe "GET /" do
    subject { response }

    let(:application) { Doorkeeper::Application.find_by!(name: "React SPA API Client") }

    before do
      application
      get "/"
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_rendered "spa/index", "layouts/application" }
    it { expect(response.body).to include "<div id=\"spa\" data-client-id=\"#{application.uid}\"></div>" }
  end
end
