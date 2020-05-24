# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  article_id  :bigint
#  thread_id   :integer
#  message     :text             not null
#  likes_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
