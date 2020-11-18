class RemoveOldCommentCountOnArticle < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :comment_count
  end
end
