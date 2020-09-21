class ArticlesController < ApplicationController

    def index
      @articles = Article.includes(:user, :last_comment).all
    end

    def new
      @article = Article.new
    end

    def create
      @article = Article.create!(article_params)
      if @article.save!
        return redirect_to article_path(@article), notice: I18n.t()
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
      puts "----"
      puts article_params
      if @article
        @article.update!(article_params)
        if @article.save!
          return redirect_to article_path(@article), notice: I18n.t('controller.articles.update_success')
        end
      end
    end

    private
    def article_params
      # params.permit(:title, :subtitle, :content, :privacy)
      params.require(:article).permit(:user_id, :title, :subtitle, :content, :state)
    end
end
