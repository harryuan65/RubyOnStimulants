class ApplicationController < ActionController::Base
  before_action :show_info
  def show_info
    puts '========================'
    puts "Request: #{request.method} #{request.path}"
    puts "Controller: #{params[:controller]}##{params[:action]}"
    puts '========================'
  end

  def if_user
    if params[:controller]!="devise/sessions#new" && params[:controller]!="home#index" && !current_user
      redirect_to new_user_session_path
    end
  end
end
