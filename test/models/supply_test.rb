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

require 'test_helper'

class SupplyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
