describe SwaggerController do
  describe "#new" do
    subject { described_class.new }

    it { is_expected.to be_a described_class }
    it { is_expected.to be_a ApplicationController }
  end

  describe "Assigns @uid" do
    let(:application) { create(:doorkeeper_application, :with_required_attributes) }

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
    it { is_expected.to have_rendered "swagger/index", "layouts/swagger" }
  end
end
