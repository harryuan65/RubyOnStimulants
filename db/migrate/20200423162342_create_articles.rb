class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.references :user, index: true
      t.string :title, index: true, null: false
      t.text :content, null: false
      t.integer :like_count, index: true, default: 0
      t.integer :view_count, index: true, default: 0
      t.integer :comment_count, index: true, default: 0
      t.integer :privacy, index: true, default: 0
      t.timestamps
    end
  end
end
