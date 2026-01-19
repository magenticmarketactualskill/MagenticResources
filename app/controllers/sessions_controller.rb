class SessionsController < ApplicationController
  def new
    redirect_to root_path if user_signed_in?
  end

  def create
    user = User.find_by("LOWER(email) = ?", params[:email].downcase.strip)

    if user
      session[:user_id] = user.id
      user.update(last_signed_in_at: Time.current)
      redirect_to root_path, notice: "Welcome back, #{user.display_name}!"
    else
      flash.now[:alert] = "No account found with that email."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    redirect_to login_path, notice: "You have been signed out."
  end
end
