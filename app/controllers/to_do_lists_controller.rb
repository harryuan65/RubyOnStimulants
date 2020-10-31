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

    render json: @list.items
  end

  def create
    param! :name, String, required: true
    name = params[:name]
    @list = ToDoList.create!(name: name, user_id: @current_user.id)
    render json: {success: true, flash: I18n.t("controller.to_do_lists.create_success", name: name), list: @list.as_json}.camelize_for_js
  end

  def update
    param! :id, Integer, required: true
    param! :name, String, required: true
    name = params[:name]
    id = params[:id]

    @list = ToDoList.find(:id)
    @list.update!(name: name)

    render json: {success: true, list: @list.as_json}.camelize_for_js
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
