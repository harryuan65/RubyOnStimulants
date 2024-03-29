class ApplicationController < ActionController::Base
  include Parser
  include Error::ErrorHandler
  # before_action :set_locale_by_api
  # before_action :show_info
  around_action {|controller, action| switch_locale(&action)}
  before_action :show_req_env_dev
  before_action :set_title
  skip_forgery_protection only:[:prod_test]
  skip_before_action :verify_authenticity_token, only:[:post_test]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def switch_locale(&action)
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
    locale = extract_locale_from_accept_language_header

    if locale.nil? || I18n.available_locales.exclude?(locale)
      locale = :en
      logger.debug "* Locale not supported. Set to '#{locale}'"
    else
      logger.debug "* Locale set to '#{locale}'"
    end
    I18n.locale = locale
    I18n.with_locale(locale, &action)
  end

  def show_req_env_dev
    # puts request.env.to_h.keys
    # puts request.env['HTTP_ACCEPT_LANGUAGE']
  end

  def set_title
    case params[:controller]
    when "users/sessions" then @title=I18n.t('controller.title.sign_in')
    when "home"       then @title=I18n.t('controller.title.home')
    when "accounts"   then @title=I18n.t('controller.title.accounts')
    when "excel"      then @title=I18n.t('controller.title.excel')
    when "to_do_list" then @title=I18n.t('controller.title.to_do_list')
    when "supplies"   then @title=I18n.t('controller.title.supplies')
    when "articles"   then @title=I18n.t('controller.title.articles')
    when "words"   then @title=I18n.t('controller.title.words')
    else
      if "#{params[:controller]}##{params[:action]}" == "application#route_not_found"
        @title = I18n.t('controller.title.not_found')
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
    puts "Request IP: #{request.remote_ip}"
    puts "Path: #{request.method} #{request.path}"
    puts "Controller: #{params[:controller]}##{params[:action]}"
    puts '========================'
  end

  def post_test
    # raise ActiveRecord::RecordNotFound # test ajax fail
    if request.headers["REMOTE_ADDR"] == "::1"
      puts("==================")
      puts "Headers:"
      request.headers.each{|k,v| puts k.to_s+': '+v.to_s}
      puts "\nParameters:"
      params.each{|k,v| puts k.to_s+': '+v.to_s}
      puts("==================")
      render json: {success: true}
    else
      render_error "Unauthorized"
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

  def route_not_found
    raise ActionController::RoutingError.new("Route Not Found")
  end

  # This is found on https://stackoverflow.com/questions/4709109/base-64-url-decode-with-ruby-rails
  # when users have used facebook to login, which allows harrysworkspace to register in facebook/settings/application
  # and decided to revoke, facebook will call this route set in developer settings
  def dev_cancel_fb
    param! :signed_request, String, required: true

    #parsing flow referred to https://developers.facebook.com/docs/games/gamesonfacebook/login#parsingsr
    signed_request = params[:signed_request]
    encoded_sig, encoded_payload = signed_request.split('.')
    secret = ENV['FACEBOOK_APP_SECRET']

    sig = Base64.decode64(encoded_sig.tr('-_','+/')).unpack('H*')[0]
    data = JSON.parse(Base64.decode64(encoded_payload.tr('-_','+/')))

    expected_sig = OpenSSL::HMAC.hexdigest('SHA256', secret, encoded_payload)

    if expected_sig != sig
      raise 'Invalid signature'
    end

    @user = User.find_by!(fb_uid: data["user_id"])
    @user.update(fb_uid: nil, fb_token: nil)

    return render json: {success: true}
  end

  def err
    raise NoMethodError.new("這家咖啡廳太讚了")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :password])
  end

  private

  # def set_locale_by_api
  #   I18n.locale = params[:locale]&.to_sym || :'en'
  # end

  def extract_locale_from_accept_language_header
    lang = request.env['HTTP_ACCEPT_LANGUAGE']
    lang.split(",")[0].to_sym if lang
  end
end
