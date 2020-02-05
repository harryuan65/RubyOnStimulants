class CreateToDoLists < ActiveRecord::Migration[5.2]
  def change
    create_table :to_do_lists do |t|
      t.string :thing
      t.boolean :done
      t.boolean :need_remind
      t.integer :remind_type
      t.datetime :remind_at
      t.string :who
      t.string :postscript
      t.references :user, index: true
      t.timestamps
    end
  end
end
