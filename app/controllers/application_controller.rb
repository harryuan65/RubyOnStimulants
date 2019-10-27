class ApplicationController < ActionController::Base
  include CSVParser
  include Global
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
  def download
    filepath = params[:file_path]
    send_file(filepath,filename:filepath.split('/')[-1],type:'application/csv' ,status:202)
  end
end
