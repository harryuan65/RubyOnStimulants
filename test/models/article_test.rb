# == Schema Information
#
# Table name: articles
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  title         :string           not null
#  content       :text             not null
#  like_count    :integer          default(0)
#  view_count    :integer          default(0)
#  comment_count :integer          default(0)
#  privacy       :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
