class AddNewLikesCountOnArticle < ActiveRecord::Migration[6.0]
  def up
    add_column :articles, :likes_count, :integer
  end

  def down
    remove_column :articles, :likes_count, :integer
  end
end
