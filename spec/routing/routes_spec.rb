describe "Rails.application.routes.draw" do
  it { expect(get: "/").to route_to(controller: "spa", action: "index") }
  it { expect(get: "/swagger").to route_to(controller: "grape_swagger_rails/application", action: "index") }
  it { expect(post: "/users").to route_to(controller: "users/registrations", action: "create") }
  it { expect(post: "/oauth/token").to route_to(controller: "doorkeeper/tokens", action: "create") }
  it { expect(post: "/oauth/revoke").to route_to(controller: "doorkeeper/tokens", action: "revoke") }
  it { expect(get: "/does_not_exists").not_to be_routable }
end
