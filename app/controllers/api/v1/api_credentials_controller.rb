class API::V1::ApiCredentialsController < ApplicationController
  load_and_authorize_resource param_method: :permitted_params

  def show
    @api_credential = ApiCredential.find(params[:id])
    render json: @api_credential
  end

  def index
   @api_credentials = current_user.api_credentials
   render json: @api_credentials
  end

  def create
    @api_credential = current_user.api_credentials.build(permitted_params)
    if @api_credential.save
      render json: @api_credential, status: :created, location: @api_credential
    else
      render json: @api_credential.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @api_credential.destroy
    head :no_content
  end

  def update
    if @api_credential.update(permitted_params)
      render json: @api_credential, location: @api_credential
    else
      render json: @api_credential.errors, status: :unprocessable_entity
    end
    end

  private
  def permitted_params
    params.require(:api_credential).permit(:api_key, :api_id, :provider)
  end
end
