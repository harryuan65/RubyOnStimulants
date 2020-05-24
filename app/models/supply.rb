# == Schema Information
#
# Table name: supplies
#
#  id                  :bigint           not null, primary key
#  name                :string
#  category            :integer
#  quantity            :integer
#  earliest_expiration :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

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
