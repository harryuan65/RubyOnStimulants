class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:backup, :backup_acked]
  require 'redcarpet/render_strip'
  layout "articles/layout"
  def index
    @limit = 10
    @offset = params[:offset] || 0
    if current_user
      @articles = Article.includes(:user, :tags).where(state: :published).or(
                    Article.includes(:user, :tags).where(state: [:draft, :hidden], user_id: current_user.id)
                  ).order(id: :desc).limit(@limit).offset(@offset)
    else
      @articles = Article.includes(:user, :tags).where(state: :published).order(id: :desc).limit(@limit).offset(@offset)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @article = Article.new
  end

  def create
    permitted_params = article_params
    tag_str = permitted_params.delete(:tags)

    @article = Article.create!(permitted_params)
    @article.state = :draft if @article.state.nil?

    if tag_str!=""
      tags = tag_str.split(',').map(&:strip)
    end

    begin
      @article.update!(tag_names: tags)
      @article.save!
      return redirect_to article_path(@article), notice: I18n.t('controller.articles.update_success')
    rescue => exception
      redirect_to article_path(@article), alert: exception.to_s
    end
  end

  def show
    @article = Article.find(params[:id])
    @is_author = current_user && current_user.email == @article.user.email
    if !@is_author && @article.hidden?
      @article = nil
      return render "shared/route_not_found"
    end
    @article.increment!(:view_count)
    # render plain: render_to_string("show")
    # @markdown = Redcarpet::Markdown.new(renderer, extensions = {})
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    permitted_params = article_params
    tag_str = permitted_params.delete(:tags)
    tags = @article.tag_names

    if tag_str!=""
      tags = tag_str.split(',').map(&:strip)
    end

    if @article
      begin
        if tags == @article.tag_names
          @article.update!(permitted_params)
        else
          @article.update!(permitted_params.merge(tag_names: tags))
        end

        @article.save!
        return redirect_to article_path(@article), notice: I18n.t('controller.articles.update_success')
      rescue => exception
        redirect_to article_path(@article), alert: exception.to_s
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    begin
      @article.destroy
      return redirect_to articles_path, notice: I18n.t('controller.articles.delete_success')
    rescue => exception
      return redirect_to article_path(@article), alert: I18n.t('controller.articles.delete_failed') + "error: " + exception.to_s
    end
  end

  def search
    @keyword = params[:keyword]
    article_ids = Article.search_with(@keyword)
    @articles = Article.find_with_sequence(article_ids)

    render "search_result"
  end

  def backup_settings
  end

  def backup
    if current_user.premium?
      user_name = (current_user.email.split('@')[0]).gsub(/[^0-9a-zA-Z]/, '')
      output_dir = 'tmp/articles_output'
      file_name = ["articles", user_name, Date.current.to_s(:db)].join("_")
      file_path = "#{output_dir}/#{file_name}.zip"
      FileUtils.mkdir(output_dir) unless File.directory?(output_dir)
      File.open(file_path, "w") do |file|
        file.chmod(0644)
        file_path = file.path
        Article.backup( user_id: current_user.id,
                        file_path: file_path,
                        use_range: params[:use_range],
                        id_range: params[:id_range])
      end
      file = File.open(file_path, "r")
      # send_file will act async
      send_data file.read, type: 'application/zip', filename: "#{file_name}.zip"
      File.delete(file_path)
    else
      raise Error::UnauthorizedError
    end
  end

  def backup_acked
    if current_user.premium?
      user_name = (current_user.email.split('@')[0]).gsub(/[^0-9a-zA-Z]/, '')
      file_name = params[:file_name]
      if File.file?("tmp/articles_output/#{file_name}") && file_name.include?(user_name)
        File.delete(params[:file_name])
        respond_to do |format|
          format.js {return render json:{success: true}}
        end
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      raise Error::UnauthorizedError
    end
  end

  private
  def article_params
    # params.permit(:title, :subtitle, :content, :privacy)
    params.require(:article).permit(:user_id, :title, :subtitle, :content, :state, :category, :tags)
  end
end
