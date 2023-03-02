describe "spa/index" do
  before do
    assign(:uid, application.uid)
    render
  end

  let(:application) { Doorkeeper::Application.find_by!(name: "React SPA API Client") }

  it { expect(controller.request.path_parameters).to eq action: "index", controller: "spa" }
  it { expect(rendered).to include "<div id=\"spa\" data-client-id=\"#{application.uid}\"></div>" }
end
