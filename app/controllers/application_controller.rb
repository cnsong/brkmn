class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Insufficient privileges. Access denied."
    redirect_to urls_path
  end

  def is_authenticated
    # In production with the apache config in README.rdoc there should never be an app-level
    # authentication request.
    authenticate_or_request_with_http_basic 'The Berkman URL Shortener' do |username, password|
      @current_user = User.find_by_username(username)
    end
  end

  def current_user
    @current_user
  end
end
