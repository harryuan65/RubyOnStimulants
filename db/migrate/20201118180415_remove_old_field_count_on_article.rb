class RemoveOldFieldCountOnArticle < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :comment_count
    remove_column :articles, :like_count
  end
end
