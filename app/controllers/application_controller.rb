class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "Please sign in to continue."
      redirect_to login_path
    end
  end

  def require_admin!
    unless current_user&.admin?
      flash[:alert] = "You don't have permission to access this page."
      redirect_to root_path
    end
  end
end
