describe "spa/index" do
  before do
    assign(:uid, application.uid)
    render
  end

  let(:application) { create(:doorkeeper_application, :with_required_attributes) }

  it { expect(controller.request.path_parameters).to eq action: "index", controller: "spa" }
  it { expect(rendered).to include "<div id=\"spa\" data-client-id=\"#{application.uid}\"></div>" }
end
