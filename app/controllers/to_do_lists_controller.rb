class ToDoListsController < ApplicationController
  before_action :set_user
  layout "to_do_lists/layout"

  def index
    @lists = ToDoList.all
    # @lists = []
    @lists = @lists.to_a.push ToDoList.new
    @z_index_count = @lists.size
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @list = ToDoList.includes(:items).find params[:id]
    # respond_to do |format|
    #   format.html {render json:{message: "Unauthorized"}}
    #   format.js {render json: @list.items}
    # end
    render json: @list.items
  end

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
