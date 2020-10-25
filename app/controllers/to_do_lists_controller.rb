class ToDoListsController < ApplicationController
  before_action :set_user

  def index
    @list = ToDoList.first
  end

  def show
    @list = ToDoList.includes(:items).find params[:id]
  end
  # def add_todo
  #   begin
  #     @item = @current_user.to_do_lists.create!(
  #         thing: todo_params[:thing],
  #         done: false,
  #         deadline: todo_params[:deadline],## parse  "to_do_list"=>{"deadline(1i)"=>"2020", "deadline(2i)"=>"2", "deadline(3i)"=>"19", "deadline(4i)"=>"02", "deadline(5i)"=>"05"}
  #         postscript: todo_params[:postscript]
  #     )
  #     if @item.save
  #       flash[:notice] = "成功新增item"
  #     end
  #   rescue=>e
  #     flash[:alert] = "#{e}"
  #     puts "#{e}"
  #   end
  # end

  # def delete_todo
  #   begin
  #     ToDoList.find_by(id: params[:id]).delete
  #     return render json:{success: true, message:"deleted #{params[:id]}"}
  #   rescue=>e
  #     return render json:{success: false, message:"#{e}"}
  #   end
  # end

  private

  def todo_params
    params.permit(ToDoList.column_names.map{|c| c.to_sym})
  end

  def set_user
    if current_user
      @current_user = User.find_by(email: current_user.email)
    else
      redirect_to new_user_session_path
    end
  end
end
