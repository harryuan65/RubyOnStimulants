class RemovePrivacyAddCategoryForArticles < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :privacy
    add_column :articles, :category, :string
    add_index :articles, :category
  end
end
