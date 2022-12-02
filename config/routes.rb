Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    use_doorkeeper
    root "spa#index"
    mount API::Base => "/api"
    mount GrapeSwaggerRails::Engine => "/swagger"
  end
end
