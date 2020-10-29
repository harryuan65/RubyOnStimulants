class ArticlesController < ApplicationController
  require 'redcarpet/render_strip'
  layout "articles/layout"
  def index
    @offset = params[:offset] || 0
    if current_user
      @articles = Article.includes(:user, :last_comment, :tags).where(state: :published).or(
                    Article.includes(:user, :last_comment, :tags).where(state: [:draft, :not_public], user_id: current_user.id)
                  ).order(id: :desc).limit(50).offset(@offset)
    else
      @articles = Article.includes(:user, :last_comment, :tags).where(state: :published).order(id: :desc).limit(50).offset(@offset)
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
    if !@is_author && @article.not_public?
      @article = nil
      return render "shared/route_not_found"
    end
    @article.increment!(:view_count)
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
  private
  def article_params
    # params.permit(:title, :subtitle, :content, :privacy)
    params.require(:article).permit(:user_id, :title, :subtitle, :content, :state, :category, :tags)
  end
end
