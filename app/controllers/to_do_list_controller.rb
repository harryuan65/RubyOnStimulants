class ToDoListController < ApplicationController
    before_action :set_user

    def index
      @todos = ToDoList.all
      @date = taipei_time(Time.now.to_date).strftime("%Y/%m/%d")
    end

    def add_todo
      begin
        @item = @current_user.to_do_lists.create!(
            thing: todo_params[:thing],
            done: false,
            need_remind: todo_params[:need_remind],
            remind_type: todo_params[:remind_type],
            remind_at: (todo_params[:need_remind] ? Time.parse(todo_params[:remind_at]) : nil),
            postscript: todo_params[:postscript],
            deadline: todo_params[:deadline]
        )
        Slack::Web::Api::Endpoints::Reminders.reminders_add({text:"#{@item.thing},#{@item.postscript}",time:"#{@item.remind_at.strftime("%m/%d %l:%M:%S")}"}) if @item.need_remind
        # SlackNotifier::CLIENT.ping "/remind #smallbai #{@item.thing},#{@item.postscript} on #{@item.remind_at.strftime("%m/%d")} #{@item.remind_at.strftime("%k:%M:%S")}" if @item.need_remind
        if @item.save
          flash[:notice] = "成功新增item"
        end
      rescue=>e
        flash[:alert] = "#{e}"
        puts "#{e}"
      end
    end

    def delete_todo
      begin
        ToDoList.find_by(id: params[:id]).delete
        return render json:{success: true, message:"deleted #{params[:id]}"}
      rescue=>e
        return render json:{success: false, message:"#{e}"}
      end
    end

    private

    def todo_params
        params.permit(ToDoList.column_names.map{|c| c.to_sym})
    end

    def set_user
      @current_user = User.find_by(email: current_user.email)
    end
end
