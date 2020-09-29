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

class CommentReply < Comment
  # belongs_to :thread, foreign_key: 'thread_id', class_name: 'Comment'
  belongs_to :thread, class_name: 'Comment'
end
