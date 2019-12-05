class ToDosController < ApplicationController
    def index
        @todos = ToDo.all
    end
    def add_todo
    end
end
