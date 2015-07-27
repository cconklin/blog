class Admin::UsersController < ApplicationController

  load_and_authorize_resource
  before_action :authenticate_user!
  
  def index
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to [:admin, :users], notice: "User was updated successfully."
    else
      render action: "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to [:admin, :users]
  end

  private

  def user_params
    # Get the user params, dump password if it is blank
    user_parameters = params.require(:user).reject { |k, v| v.blank? && k == "password"}
    user_parameters.permit(:name, :email, :password, roles: [])
  end
end
