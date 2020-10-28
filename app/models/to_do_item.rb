class ToDoItem < ApplicationRecord
  belongs_to :list, class_name: "ToDoList", foreign_key: "to_do_list_id", counter_cache: :items_count
  belongs_to :user

  after_create :set_default_position

  def set_default_position
    update!(position: self.list.items_count) if position.blank?
  end
end
