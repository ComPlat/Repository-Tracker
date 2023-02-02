Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    root "spa#index"

    mount API::Base => "/api"
    mount GrapeSwaggerRails::Engine => "/swagger"

    devise_for :users, controllers: {registrations: "users/registrations", confirmations: "users/confirmations"}

    use_doorkeeper do
      skip_controllers :authorizations, :applications,
        :authorized_applications
    end

    get "/*path", to: "spa#index"
  end
end
