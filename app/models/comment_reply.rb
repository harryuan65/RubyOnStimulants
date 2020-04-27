class CommentReply < Comment
  belongs_to :thread, foreign_key: 'thread_id', class_name: 'Comment'
end
