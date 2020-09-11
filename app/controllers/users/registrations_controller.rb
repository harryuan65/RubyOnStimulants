class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
    @minimum_password_length = 6
    render 'users/registrations/new', layout: false
  end

  def create
    puts user_params
    email = user_params[:email]
    password = user_params[:password]
    if User.exists?(email: email)
      redirect_to new_user_registration_path, alert: I18n.t("devise.registrations.already_exists")
    else
      begin
        ActiveRecord::Base.transaction do
          # user = User.create!(email: email)
          user = User.new
          user.email= email
          user.password = password
          user.save
        end
        return redirect_to new_user_session_path, notice: I18n.t("devise.registrations.signed_up")
      rescue => exception
        return redirect_to new_user_registration_path, alert: I18n.t("errors.exception", message: exception.to_s)
      end
    end
  end

  private

  def user_params
    params.fetch(:user)
  end
end