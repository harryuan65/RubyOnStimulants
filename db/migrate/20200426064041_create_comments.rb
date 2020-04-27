class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :article, index: true
      t.integer :thread_id, index: true, default: nil
      t.text :message, :null => false
      t.integer :likes_count, default: 0
      t.timestamps
    end
  end
end
