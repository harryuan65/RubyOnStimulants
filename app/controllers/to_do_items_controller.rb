class ToDoItemsController < ApplicationController
  before_action :set_user

  def create
    list = ToDoList.find params[:to_do_list_id]
    @item = ToDoItem.new(list: list, name: to_do_item_params[:name], user_id: @current_user.id)
    @item.save!

    render json: {flash: I18n.t('controller.to_do_items.create_success', name: @item.name), item: @item}
  end

  def update
    puts "================"
    puts to_do_item_params
    puts params
    puts "================"
    puts params[:id]
    id = params[:id]
    @item = ToDoItem.find id
    @item.update!(to_do_item_params)

    render json: {flash: I18n.t('controller.to_do_items.update_success', name: @item.name), item: @item}
  end

  private

  def to_do_item_params
    params.require(:to_do_item).permit!
  end

  def set_user
    if current_user
      @current_user = User.find_by(email: current_user.email)
    else
      redirect_to new_user_session_path
    end
  end
end
