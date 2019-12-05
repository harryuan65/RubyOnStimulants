class ValidatorController < ApplicationController
    def index
    end
    def see_valid
      if params[:email]
       response = Truemail.validate(params[:email][0])
       return render json:{is_valid_mail: response.result.success}
      end
    end
end
