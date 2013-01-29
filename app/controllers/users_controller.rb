class UsersController < ApplicationController
  force_ssl

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to log_in_path, :notice => "Signed up! Please log in."
    else
      render "new"
    end
  end
end