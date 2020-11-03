class ToDoItemsController < ApplicationController
  before_action :set_user

  def create
    list = ToDoList.find params[:to_do_list_id]
    @item = ToDoItem.new(list: list, name: to_do_item_params[:name], user_id: @current_user.id)
    @item.save!

    render json: {flash: I18n.t('controller.to_do_items.create_success', name: @item.name), item: @item}
  end

  def update
    id = params[:id]
    @item = ToDoItem.find id
    @item.update!(to_do_item_params)

    render json: {flash: I18n.t('controller.to_do_items.update_success', name: @item.name), item: @item}
  end

  def destroy
    id = params[:id]
    @item = ToDoItem.includes(:list).find id
    @item.destroy
    render json: {flash: I18n.t('controller.to_do_items.delete_success', name: @item.name), item: @item}
  end

  def update_position
    id = params[:id]
    position = params[:position]
    @item = ToDoItem.find id
    @item.set_list_position(position) if @item.position!=position
    render json: {flash: I18n.t('controller.to_do_items.update_success', name: @item.name), item: @item}
  end
  private

  def to_do_item_params
    params.require(:to_do_item).permit!
  end

  def set_user
    if current_user
      @current_user = current_user
    else
      redirect_to new_user_session_path
    end
  end
end
