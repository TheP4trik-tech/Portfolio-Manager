class ApiCredentialsController < ApplicationController
  def new
    @api_credential = ApiCredential.new
  end
  def index
    user = current_user
    @api_credentials = current_user.api_credentials
  end
end
