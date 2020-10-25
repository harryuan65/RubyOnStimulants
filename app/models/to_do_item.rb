class ToDoItem < ApplicationRecord
  belongs_to :list, class_name: "ToDoList", foreign_key: "to_do_list_id"
  belongs_to :user
end
