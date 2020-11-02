class ToDoListsController < ApplicationController
  before_action :set_user
  layout "to_do_lists/layout"

  def index
    @lists = ToDoList.includes(:items).all.order(id: :asc)
    @lists = @lists.to_a.push ToDoList.new
    @lists_count = @lists.size
    @z_index_count = @lists.size
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    param! :name, String, required: true
    name = params[:name]
    @list = ToDoList.create!(name: name, user_id: @current_user.id)
    render json: {success: true, flash: I18n.t("controller.to_do_lists.create_success", name: name), list: @list}
  end

  def update
    param! :id, Integer, required: true
    param! :name, String, required: true
    name = params[:name]
    id = params[:id]

    @list = ToDoList.find(id)
    @list.update!(name: name)

    render json: {success: true, flash: I18n.t("controller.to_do_lists.update_success", name: name), list: @list}
  end

  def destroy
    id = params[:id]
    @list = ToDoList.find(id)
    @list.destroy
    redirect_to to_do_lists_path, format: :js, notice: I18n.t("controller.to_do_lists.delete_success", name: @list.name)
  end
  private

  def set_user
    if current_user
      @current_user = User.find_by(email: current_user.email)
    else
      redirect_to new_user_session_path
    end
  end
end
