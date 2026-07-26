class ApiCredentialsController < ApplicationController
  def new
    user = current_user
  end
  def index
    user = current_user
    @api_credentials = current_user.api_credentials
  end
end
