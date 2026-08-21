class ApiCredentialsController < ApplicationController
  def index
    user = current_user
    @api_credentials = current_user.api_credentials
    @api_credential = ApiCredential.new
  end

  def new
    @api_credential = ApiCredential.new
  end
  def edit
    @api_credential = ApiCredential.find(params[:id])
  end

  def update
    @api_credential = ApiCredential.find(params[:id])
    if @api_credential.update(permitted_params)
      redirect_to api_credentials_path, notice: "Api credential updated."
    else
      render edit_api_credential_path, alert: "Api credential update failed"
    end
  end

  # controller
  def create
    @api_credential = current_user.api_credentials.build(permitted_params)
    if @api_credential.save
      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  private
  def permitted_params
    params.require(:api_credential).permit(:api_key, :api_id, :provider)
  end
end
