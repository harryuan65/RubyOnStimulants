class RemoveOldModels < ActiveRecord::Migration[6.1]
  def change
    reversible do |migration|
      migration.up do
        drop_table :supplies
        drop_table :to_do_lists
        drop_table :to_do_items
      end
      migration.down do
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
        create_table :supplies do |t|
          t.string :name
          t.integer :category
          t.integer :quantity
          t.datetime :earliest_expiration

          t.timestamps
        end
        create_table :to_do_lists do |t|
          t.references :user, index: true
          t.string :name, null: false
          t.integer :items_count, default: 0
          t.string :bg_color
          t.timestamps
        end
      end
    end
  end
end
