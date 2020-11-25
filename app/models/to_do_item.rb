class ToDoItem < ApplicationRecord
  belongs_to :list, class_name: "ToDoList", foreign_key: "to_do_list_id", counter_cache: :items_count
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true
  enum state: [:pending, :finished]

  acts_as_list scope: :list

end
