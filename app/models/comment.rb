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

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article, counter_cache: true
  has_many :comment_replies, foreign_key: 'thread_id', class_name: 'CommentReply'
end
