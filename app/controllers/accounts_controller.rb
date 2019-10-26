class AccountsController < ApplicationController
    def index
      # if "#{params[:controller]}##{params[:action]}" == "accounts#index"
      #    flash[:notice]="Welcome to accounts!"
      # end
      @new_purchase_history = Account.new
    end

    def new
    end

    def add
      render json:{message:"Success",data:params.fetch(:account)}
    end

    def all
    end

    def report
    end

end
