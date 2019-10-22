# == Schema Information
#
# Table name: accounts
#
#  id          :bigint           not null, primary key
#  currency    :string
#  price       :integer
#  content     :string
#  category    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#  user_id     :bigint
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
