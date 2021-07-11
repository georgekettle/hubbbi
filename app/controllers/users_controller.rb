class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "Your profile has been successfully updated"
    else
      render :edit, alert: "Oops, there was an error updating your profile"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:full_name, :display_name)
  end
end
