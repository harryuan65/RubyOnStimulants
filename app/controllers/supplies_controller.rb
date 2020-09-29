class SuppliesController < ApplicationController
  before_action :check_valid_user

  def index
    @supplies = Supply.select("category, sum(quantity) as quantity").group("category")
  end

  def all
    @new_supply = Supply.new
    @supplies = Supply.all.order(:earliest_expiration=>:asc)
  end

  def create
    new_supply = Supply.create!(
      name: supply_params[:name],
      category: parse_category(supply_params),
      quantity: supply_params[:quantity],
      earliest_expiration: supply_params[:earliest_expiration]
    )
    if new_supply.save!
      flash[:notice] = "成功新增#{new_supply.name}"
      redirect_to all_supplies_path
    else
      return render json:{message: "錯誤！無法新增"}
    end
  end

  def state
  end

  def show
  end

  def destroy
    if params[:id]
      sup = Supply.where(id: params[:id]).destroy_all
      if sup&.first
        flash[:notice] = "成功刪除 id = #{sup.first.id} #{sup.first.name}"
        redirect_to action: 'index'
      else
        return render json:{success: false, reason: "#{params[:id]} Not found"}
      end
    else
      return render json:{success: false}
    end
  end

  private
  def supply_params
    params.fetch(:supply).permit(Supply.column_names)
  end
  def parse_category supply_params
    case supply_params['category']
    when '正餐' #rails 5 可以這樣
      0
    when '飲料'
      1
    when '沖泡式'
      2
    when '衛生紙'
      3
    when '餅乾'
      4
    when '水'
      5
    else
      raise "unknown type:#{supply_params['category']}"
    end
  end

  def check_valid_user
    puts current_user.email
    if !['matcha110817@gmail.com', 'harryuan.65@gmail.com'].include?(current_user.email)
      return render 'shared/result',locals:{status:false, error:"Unauthorized"}, status: 401
    end
  end
end