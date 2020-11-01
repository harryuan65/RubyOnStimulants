module ToDoListsHelper
  def get_margin(is_even:, mid:, i:)
    if is_even
      if i<mid-1
        "margin-right: -120px"
      elsif i==mid-1
        "margin-right: -60px"
      elsif i==mid
        "margin-left: -60px"
      else
        "margin-left: -120px"
      end
    else
      if i<mid
        "margin-right: -120px"
      else
        "margin-left: -120px"
      end
    end
  end
end
