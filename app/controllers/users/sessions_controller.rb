class Users::SessionsController < Devise::OmniauthCallbacksController
  def new
    @user = User.new
  end

  def destroy
    puts('=============Destroy session: Signed out========')
    sign_out current_user
    reset_session
    redirect_to new_user_session_path
  end

end