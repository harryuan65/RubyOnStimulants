class AccountsController < ApplicationController
    def index
      # if "#{params[:controller]}##{params[:action]}" == "accounts#index"
      #    flash[:notice]="Welcome to accounts!"
      # end
      @new_purchase_history = Account.new
      @todays_purchase_histories = User.find_by_email(current_user.email).accounts.where(created_at: Time.now.in_time_zone('Taipei').beginning_of_day..Time.now.in_time_zone('Taipei').end_of_day)
    end

    def new
    end

    def add
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.reset_pk_sequence!("accounts")
        u = User.find_by_email(current_user.email)
        u.accounts.create!(
          content:account_params[:content],
          price: account_params[:price],
          category:account_params[:category],
          currency:account_params[:currency],
          description:account_params[:description]
        )
      end
      render json:{message:"Success",data:params.fetch(:account)}
    end

    def all
    end

    def report
    end

    private def account_params
      params.fetch(:account)
    end
end
