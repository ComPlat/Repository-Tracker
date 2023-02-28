describe "Rails.application.routes.draw" do
  it { expect(get: "/").to route_to(controller: "spa", action: "index") }
  it { expect(get: "/swagger").to route_to(controller: "swagger", action: "index") }

  it { expect(post: "/users").to route_to(controller: "users/registrations", action: "create") }
  it { expect(get: "/users/confirmation").to route_to(controller: "users/confirmations", action: "show") }
  it { expect(post: "/users/password").to route_to(controller: "users/passwords", action: "create") }
  it { expect(put: "/users/password").to route_to(controller: "users/passwords", action: "update") }

  it { expect(post: "/oauth/token").to route_to(controller: "doorkeeper/tokens", action: "create") }
  it { expect(post: "/oauth/revoke").to route_to(controller: "doorkeeper/tokens", action: "revoke") }

  it { expect(get: "/does_not_exists").not_to be_routable }
end
