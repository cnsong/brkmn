class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl
  helper_method :logged_in?
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section." 
      redirect_to log_in_path # Prevents the current action from running
    end
  end
  
  private
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  
  def logged_in?
    current_user
  end  
end
