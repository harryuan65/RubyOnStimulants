# == Schema Information
#
# Table name: to_do_lists
#
#  id         :bigint           not null, primary key
#  thing      :string
#  done       :boolean
#  postscript :string
#  deadline   :datetime
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ToDoListTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
