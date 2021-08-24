class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :edit_avatar]
  before_action :hide_all_navbars

  def edit
  end

  def update
    if params[:user].nil? || (params[:user][:avatar] && params[:user][:avatar]&.length < 1)
      redirect_back fallback_location: edit_user_path, alert: "Oops, there was an error updating your profile"
    elsif @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "Your profile has been successfully updated"
    else
      render :edit, alert: "Oops, there was an error updating your profile"
    end
  end

  def edit_avatar
  end

  private

  def update_params_to_hash

  end

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:full_name, :display_name, :avatar)
  end
end
