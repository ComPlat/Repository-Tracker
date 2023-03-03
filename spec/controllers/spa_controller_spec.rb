describe SpaController do
  describe "#new" do
    subject { described_class.new }

    it { is_expected.to be_a described_class }
    it { is_expected.to be_a ApplicationController }
  end

  describe "Assigns @uid" do
    let(:application) { create(:doorkeeper_application, :with_required_attributes, uid: ENV["DOORKEEPER_CLIENT_ID"]) }

    before do
      application
      get :index
    end

    it { expect(assigns(:uid)).to eq application.uid }
  end

  describe "GET index" do
    subject { response }

    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

    before do
      application
      get :index
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_rendered "spa/index", "layouts/spa" }
  end
end
