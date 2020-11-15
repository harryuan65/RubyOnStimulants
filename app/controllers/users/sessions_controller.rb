class Users::SessionsController < Devise::OmniauthCallbacksController
  def new
    @user = User.new
    @hide_sidebar = true
    render "users/sessions/new" #, locals: { show_sidebar: false}
  end

  def create
    email = user_params[:email]
    password = user_params[:password]
    user = User.where(email: email).first
    if user
      if user.valid_password?(password)
        sign_in user, store: true # store in session
        # set_flash_message! :notice, :signed_in 研究一下怎麼用才對
        flash[:notice] = I18n.t "devise.sessions.signed_in", kind: 'username'
        redirect_to root_path
      else
        redirect_to new_user_session_path, alert: I18n.t("devise.sessions.info_incorrect")
      end
    else
      # set_flash_message! :alert, :user_not_found # looks for zh-TW.devise.omniauth_callbacks.user.user_not_found
      redirect_to new_user_session_path, alert: I18n.t("devise.sessions.user_not_found")
      # @user = User.new
      # flash[:alert] = I18n.t("devise.sessions.user_not_found")
      # render "users/sessions/new", layout: false
    end
  end

  def destroy
    sign_out current_user
    reset_session
    # redirect_to :back # <- deprecated
    redirect_back(fallback_location: root_path)
  end

  private

  def user_params
    params.fetch(:user)
  end
end