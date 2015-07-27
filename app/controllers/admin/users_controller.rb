class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update(user_params)
      redirect_to [:admin, :users], notice: "User was updated successfully."
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to [:admin, :users]
  end

  private

  def user_params
    # Get the user params, dump password if it is blank
    user_parameters = params.require(:user).reject { |k, v| v.blank? && k == "password"}
    user_parameters.permit(:name, :email, :password)
  end
end
