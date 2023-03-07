Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    root "spa#index", to: redirect("/spa")

    mount API::Base => "/api"

    devise_for :users,
      controllers: {registrations: "users/registrations",
                    confirmations: "users/confirmations",
                    passwords: "users/passwords"}

    use_doorkeeper do
      skip_controllers :authorizations, :applications,
        :authorized_applications
    end

    get "/swagger", to: "swagger#index"
    get "/spa/*path", to: "spa#index"
  end
end
