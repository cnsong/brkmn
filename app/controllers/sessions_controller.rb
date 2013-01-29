class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      if params[:remember_me]
      	cookies.permanent[:auth_token] = user.auth_token
      else
      	cookies[:auth_token] = user.auth_token
      end
      redirect_to urls_path, :notice => "Logged in! Welcome " + user.email
    else
      flash[:error] = "Invalid Email or Password"
      redirect_to log_in_path
    end
  end
  
  def destroy
    cookies.delete(:auth_token)
    redirect_to log_in_path
  end
end
