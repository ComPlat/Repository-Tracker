class SwaggerUiController < ApplicationController
  def index
    @uid = uid
    render "index"
  end

  private

  def uid = Doorkeeper::Application.find_by!(name: "React SPA API Client").uid
end
