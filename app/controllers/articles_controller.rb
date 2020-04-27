class ArticlesController < ApplicationController

    def index
      @articles = Article.includes(:user).all
    end

    def create
    end

    def show
      @article = Article.find(params[:id])
      @article.increment!(:view_count)
    end

    def edit
    end

end
