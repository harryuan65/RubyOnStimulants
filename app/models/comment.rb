class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  has_many :comment_replies, foreign_key: 'thread_id', class_name: 'CommentReply'
end
