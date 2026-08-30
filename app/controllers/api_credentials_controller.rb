class ApiCredentialsController < ApplicationController
  load_and_authorize_resource param_method: :permitted_params
  def index
    @api_credentials = current_user.api_credentials
  end

  def new
    @api_credential = ApiCredential.new
  end

  def destroy
    @api_credential.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { render :index, notice: "Api credential was successfully destroyed." }
    end
  end
  def edit
  end

  def update
    @api_credential
    if @api_credential.update(permitted_params)
      flash[:notice] = "Api credential was successfully updated."
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        flash[:alert] = @api_credential.errors.full_messages
        format.turbo_stream
        format.html { render :edit }
      end
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
