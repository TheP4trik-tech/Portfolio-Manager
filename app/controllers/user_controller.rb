class UserController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(permitted_params)
      redirect_to user_path, notice: "Profile updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    redirect_to root_path, notice: "Account was successfully deleted."
  end

  private

  def permitted_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
