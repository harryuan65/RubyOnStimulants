class AccountsController < ApplicationController
    def index
      @new_purchase_history = Account.new
      begin
        date = "#{params[:day][:year]}/#{params[:day][:month]}/#{params[:day][:day]}"
        puts date
        @day = Date.parse(date)
      rescue => exception
        @day = DateTime.now.to_date
      end
      @user = User.find_by_email(current_user.email)
      if @user
        @todays_purchase_histories = @user.accounts.where('created_at >= :t1 AND created_at <= :t2',
          :t1=>@day.beginning_of_day,
          :t2=>@day.end_of_day
        )
        puts @todays_purchase_histories.size
      end
      @time = @day.strftime("%m/%d")
    end

    def show_day

    end

    def new
    end

    def add
      ActiveRecord::Base.transaction do
        u = User.find_by_email(current_user.email)
        record = u.accounts.create!(
          content:account_params[:content],
          price: account_params[:price],
          category:account_params[:category],
          currency:account_params[:currency],
          description:account_params[:description]
        )
        flash[:notice] = "成功新增 #{record.content} #{record.price}"
      end
      respond_to do |format|
        format.json { render json:{message:"Success", data:params.fetch(:account)} }
      end
    end

    def delete
      ActiveRecord::Base.transaction do
        if current_user && params[:from_page]
          record = Account.find(params[:id])
          confirm = record
          record.destroy!
            respond_to do |format|
              format.json { render json:{message:"Success: Delete", data:confirm} }
            end
          else
            respond_to do |format|
              format.json { render json:{message:"Unauthorized"} }
            end
        end
      end
    end

    def all
    end

    def report
    end

    private def account_params
      params.fetch(:account)
    end
end
