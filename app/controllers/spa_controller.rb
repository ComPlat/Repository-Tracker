class SpaController < ApplicationController
  layout "spa"

  def index
    @uid = uid
    render "index"
  end

  private

  def uid = ENV["DOORKEEPER_CLIENT_ID"]
end
