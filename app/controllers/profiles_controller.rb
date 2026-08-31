class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(permitted_params)
      redirect_to profiles_path(current_user), notice: "Profile updated successfully."
    else
      raise @user.errors.full_messages.inspect
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    sign_out(@user)
  end

  private

  def permitted_params
    params.require(:user).permit(:first_name, :last_name, :daily_mail_accepted, :error_mail_accepted)
  end
end
