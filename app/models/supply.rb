class Supply < ApplicationRecord
  enum category: [:meal, :drink, :powdered_drink, :tissue_paper, :cookies, :water]

  def category_name
    case self.category
    when 'meal' #rails 5 可以這樣
      '正餐'
    when 'drink'
      '飲料'
    when 'powdered_drink'
      '沖泡式'
    when 'tissue_paper'
      '衛生紙'
    when 'cookies'
      '餅乾'
    when 'water'
      '水'
    else
      "??????"
    end
  end
end
