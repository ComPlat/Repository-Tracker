describe SpaController do
  describe "#new" do
    subject { described_class.new }

    it { is_expected.to be_a described_class }
    it { is_expected.to be_a ApplicationController }
  end

  describe "Assigns @uid" do
    let(:application) { Doorkeeper::Application.find_by!(name: "React SPA API Client") }

    before do
      application
      get :index
    end

    it { expect(assigns(:uid)).to eq application.uid }
  end

  describe "GET index" do
    subject { response }

    let(:application) { Doorkeeper::Application.find_by!(name: "React SPA API Client") }

    before do
      application
      get :index
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_rendered "spa/index", "layouts/spa" }
  end
end
