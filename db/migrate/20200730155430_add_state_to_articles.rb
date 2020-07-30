class AddStateToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :state, :integer
    add_index :articles, :state
  end
end
