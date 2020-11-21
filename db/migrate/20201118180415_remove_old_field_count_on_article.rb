class RemoveOldFieldCountOnArticle < ActiveRecord::Migration[6.0]
  def up
    remove_column :articles, :comment_count
    remove_column :articles, :like_count
  end

  def down
    add_column :articles, :comment_count, :integer
    add_column :articles, :like_count, :integer
  end
end
