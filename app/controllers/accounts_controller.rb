class AccountsController < ApplicationController
    def index
    end

    def new
        @new_purchase_history = Account.new
    end

    def add
      puts '========================'
      params.each do|k,v|
          puts k.to_s + ' '+ v.to_s
      end
      puts '========================'
      render('shared/result',message:"Success",data:params.permit(Account.column_names))
    end

    def all
    end

    def report
    end

end
