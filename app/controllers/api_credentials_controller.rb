class ApiCredentialsController < ApplicationController
  def index
    user = current_user
    @api_credentials = current_user.api_credentials
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
      render :edit, alert: "Api credential update failed"
    end
  end
  def create
    @api_credential = current_user.api_credentials.build(permitted_params)
    if @api_credential.save
      flash[:notice] = "Api credential created."
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new, alert: "Api credential creation failed", status: :unprocessable_entity }
      end
    end
  end

  private
  def permitted_params
    params.require(:api_credential).permit(:api_key, :api_id, :provider)
  end
end
