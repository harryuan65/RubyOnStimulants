class ApplicationController < ActionController::Base
  include CSVParser
  include Global
  before_action :set_locale
  before_action :show_info
  before_action :set_title
  skip_forgery_protection only:[:prod_test]
  skip_before_action :verify_authenticity_token

  def set_title
    case params[:controller]
    when "users/sessions" then @title=I18n.t('title.sign_in')
    when "home"       then @title=I18n.t('title.home')
    when "accounts"   then @title=I18n.t('title.accounts')
    when "excel"      then @title=I18n.t('title.excel')
    when "to_do_list" then @title=I18n.t('title.to_do_list')
    when "supplies"   then @title=I18n.t('title.supplies')
    when "articles"   then @title=I18n.t('title.articles')
    else
      if "#{params[:controller]}##{params[:action]}" == "application#route_not_found"
        @title = I18n.t('title.not_found')
        ## TODO: add not found in locale file
      else
        @title = "Untitled"
      end
    end
  end

  def show_info
    puts '========================'
    puts "Parent pid: #{Process.ppid}"
    # puts "Group pid: #{Process.groups}"
    puts "Worker pid: #{Process.pid}"
    puts "Request: #{request.method} #{request.path}"
    puts "Controller: #{params[:controller]}##{params[:action]}"
    puts '========================'
  end

  def post_test
    puts("==================")
    request.headers.each do |k,v|
      puts k.to_s+' '+v.to_s
    end
    params.each do |k,v|
      puts k.to_s+' '+v.to_s
    end
    puts("==================")
    render json:{message:"Ok"}
  end

  def if_user
    if params[:controller]!="devise/sessions#new" && params[:controller]!="home#index" && !current_user
      redirect_to new_user_session_path
    end
  end

  # File operations: currently for Excel
  def download
    if current_user
      filepath = params[:file_path]
      send_file(filepath,filename:filepath.split('/')[-1],type:'application/csv' ,status:202)
    else
      return render 'shared/result',locals:{status:false, error:"未授權"}
    end
  end

  def delete
    if current_user
      begin
        file = params[:file_path]
        if !File.directory?(file) && isFileRoot(file)
          if File.exist?(file)
            puts "exists, deleting..."
            File.delete(file)
          else
            puts "no"
          end
          puts("Is included in file roots:#{file}")
          flash[:notice] = "成功刪除 #{file.split('/')[-1]}"
          redirect_to excel_path
        else
          return render 'shared/result',locals:{status:false, error:exception.to_s}
        end
      rescue => exception
        return render 'shared/result',locals:{status:false, error:exception.to_s}
      end
    else
      return render 'shared/result',locals:{status:false, error:"未授權"}
    end
  end

  def taipei_time time
    time.in_time_zone("Taipei")
  end

  def route_not_found
    render 'shared/route_not_found', status: :not_found
  end

  def dev_cancel_fb
    puts "*****************************"
    puts "cancelled fb authorization"
    puts params
    puts "*****************************"

    return render json{success: true}
  end

  private

  def set_locale
    I18n.locale = params[:locale]&.to_sym || :'zh-TW'
  end

end
