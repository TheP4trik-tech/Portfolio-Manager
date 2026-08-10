class ApiCredentialsController < ApplicationController
  def index
    user = current_user
    @api_credentials = current_user.api_credentials
    @api_credential = ApiCredential.new
  end
end
