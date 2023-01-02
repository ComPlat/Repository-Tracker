Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    root "spa#index"

    devise_for :users, controllers: {registrations: "users/registrations"}

    use_doorkeeper do
      skip_controllers :authorizations, :applications,
        :authorized_applications
    end

    mount API::Base => "/api"
    mount GrapeSwaggerRails::Engine => "/swagger"
  end
end
