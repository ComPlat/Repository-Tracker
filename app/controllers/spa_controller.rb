class SpaController < ApplicationController
  def index
    @uid = uid
    render "index"
  end

  private

  def uid = Doorkeeper::Application.first.uid
end
