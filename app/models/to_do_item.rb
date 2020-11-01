class ToDoItem < ApplicationRecord
  belongs_to :list, class_name: "ToDoList", foreign_key: "to_do_list_id", counter_cache: :items_count
  belongs_to :user
  before_validation :set_default_position, on: :create

  validates :user_id, presence: true
  validates :name, presence: true
  enum state: [:pending, :finished]

  def set_default_position
    update!(position: self.list.items_count+1) if position.blank?
  end
end
