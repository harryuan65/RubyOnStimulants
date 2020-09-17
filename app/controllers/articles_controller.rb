class ArticlesController < ApplicationController

    def index
      @articles = Article.includes(:user).all
    end

    def new
      @article = Article.new
    end

    def create
     @article = Article.create!(article_params)
     if @article.save!
      return render json:{success: true}
     else
      render_error "Failed to create article!"
     end
    end

    def show
      @article = Article.find(params[:id])
      @article.increment!(:view_count)
      @is_author = current_user && current_user.email == @article.user.email
    end

    def edit
      @article = Article.find(params[:id])
    end

    private
    def article_params
      params.permit(:title, :content, :privacy)
    end
end
