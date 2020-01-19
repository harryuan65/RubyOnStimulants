class ToDoListController < ApplicationController
    def index
        @todos = ToDoList.all
    end

    def add_todo
      ToDoList.create!(todo_params)
    end

    private

    def todo_params
        params.permit(ToDoList.column_names.map{|c| c.to_sym})
    end
end
