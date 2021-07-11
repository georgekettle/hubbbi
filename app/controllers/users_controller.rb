class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "Your profile has been successfully updated"
    else
      render :edit, alert: "Oops, there was an error updating your profile"
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :display_name)
  end
end
