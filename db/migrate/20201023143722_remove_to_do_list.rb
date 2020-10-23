class RemoveToDoList < ActiveRecord::Migration[6.0]
  def up
    drop_table :to_do_lists
  end

  def down
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
