class RecreateToDoList < ActiveRecord::Migration[6.0]
  def up
    drop_table :to_do_lists
    create_table :to_do_lists do |t|
      t.references :user, index: true
      t.string :name, null: false
      t.integer :items_count, default: 0
      t.string :bg_color
      t.timestamps
    end
    add_index :to_do_lists, [:user_id, :name], unique: true
    create_table :to_do_items do |t|
      t.string :name, index: true, null: false
      t.integer :state, default: 0
      t.string :description
      t.datetime :due_date
      t.references :user, index: true
      t.references :to_do_list, index: true
      t.integer :position
      t.timestamps
    end
  end

  def down
    drop_table :to_do_items
    drop_table :to_do_lists
    create_table :to_do_lists do |t|
      t.string :thing
      t.boolean :done
      t.string :postscript
      t.datetime :deadline
      t.references :user, index: true
      t.timestamps
    end
  end
end
