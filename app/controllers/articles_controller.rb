class ArticlesController < ApplicationController
  require 'redcarpet/render_strip'

  def index
    @offset = params[:offset] || 0
    if current_user
      @articles = Article.includes(:user, :last_comment).where(state: :published).or(
                    Article.includes(:user, :last_comment).where(state: :draft, user_id: current_user.id)
                  ).limit(50).offset(@offset)
    else
      @articles = Article.includes(:user, :last_comment).where(state: :published).limit(50).offset(@offset)
    end
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create!(article_params)
    if @article.save!
      return redirect_to article_path(@article), notice: I18n.t("controller.articles.create_success")
    else
      render_error "Failed to create article!"
    end
  end

  def show
    @article = Article.find(params[:id])
    @article.increment!(:view_count)
    @is_author = current_user && current_user.email == @article.user.email
    # @markdown = Redcarpet::Markdown.new(renderer, extensions = {})
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article
      @article.update!(article_params)
      if @article.save!
        return redirect_to article_path(@article), notice: I18n.t('controller.articles.update_success')
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    begin
      @article.destroy
      return redirect_to articles_path, notice: I18n.t('controller.articles.delete_success') + "error: " + exception.to_s
    rescue => exception
      return redirect_to article_path(@article), alert: I18n.t('controller.articles.delete_failed') + "error: " + exception.to_s
    end
  end
  private
  def article_params
    # params.permit(:title, :subtitle, :content, :privacy)
    params.require(:article).permit(:user_id, :title, :subtitle, :content, :state)
  end
end
