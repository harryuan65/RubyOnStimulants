class AddNewLikesCountOnArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :likes_count, :integer
  end
end
