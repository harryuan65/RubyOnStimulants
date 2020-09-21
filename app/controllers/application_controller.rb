class ApplicationController < ActionController::Base
  include CSVParser
  include Global
  before_action :set_locale
  # before_action :show_info
  before_action :show_req_env_dev
  before_action :set_title
  before_action :set_current_user
  skip_forgery_protection only:[:prod_test]
  skip_before_action :verify_authenticity_token, only:[:post_test]
  before_action :configure_permitted_parameters, if: :devise_controller?
  def show_req_env_dev
    # puts request.env.to_h.keys
  end

  def set_current_user
    puts "params[:controller]=#{params[:controller]}"
    puts "params[:controller]=#{params[:action]}"
    # render_error I18n.t('controller.general.not_logged_in') if !["home", "users/sessions", "users/omniauth_callbacks"].include?(params[:controller]) && !current_user
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
    puts("==================")
    puts "Headers:"
    request.headers.each{|k,v| puts k.to_s+': '+v.to_s}
    puts "\nParameters:"
    params.each{|k,v| puts k.to_s+': '+v.to_s}
    puts("==================")
    render json:{message:"Ok"}
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
    render 'shared/route_not_found', status: :not_found
  end

  def render_error(msg)
    @success = false
    @status = 403
    @message = msg
    return render "shared/result", layout: false
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

  def preview_markdown
    if current_user
      # options = [:fenced_code_blocks, :no_intra_emphasis, :strikethrough, :underline, :highlight, :quote]
      # output = Markdown.new(params[:content], *options).to_html.html_safe
      options = [:fenced_code_blocks, :no_intra_emphasis, :strikethrough, :underline, :highlight, :quote]
      options = options.inject({}){|res, d| res.merge({d=>true})}
      render = Redcarpet::Render::HTML.new(hard_wrap: true)
      markdown = Redcarpet::Markdown.new(render, options)
      output = markdown.render(params[:content]).gsub(/\<\/p\>/, "</p><br>").html_safe
      return render html: output
    else
      return render text: "Yee"
    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :password])
  end

  private

  def set_locale
    I18n.locale = params[:locale]&.to_sym || :'en'
  end

end
