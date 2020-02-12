class CreateToDoLists < ActiveRecord::Migration[5.2]
  def change
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
