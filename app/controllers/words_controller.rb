class WordsController < ApplicationController
    def index
      @words = Word.joins(first_definition:[:first_example]).includes(first_definition:[:first_example]).order(id: :desc).all
      @new_word = Word.new
      # @words = Word.includes(:first_definition).limit(params[:limit]).offset(params[:offset]).all
    end

    def create
      if word_params[:name]
        result = Word.document_word(word_params[:name])
        if result[:success]
          flash[:notice] = I18n.t('controller.word.create_success', word: result[:word].name)
          return render json:result
        else
          flash[:alert] = result[:error]
          return render json:result
        end
      else
        render_error I18n.t('controller.word.empty')
      end
    end

    def show
      @word = Word.includes(definitions:[:examples]).find(params[:id])
    end

    def delete
    end

    private
    def word_params
      params.fetch(:word)
    end
end
