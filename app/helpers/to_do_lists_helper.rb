module ToDoListsHelper
  def done_text bool
    bool ? "✅" : "❌"
  end
end
