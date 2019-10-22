class ApplicationController < ActionController::Base
  before_action :show_info
  def show_info
    puts '========================'
    puts "Request: #{request.method} #{request.path}"
    puts "Controller: #{params[:controller]}##{params[:action]}"
    puts '========================'
  end
end
