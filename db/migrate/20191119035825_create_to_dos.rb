class CreateToDos < ActiveRecord::Migration[5.2]
  def change
    create_table :to_dos do |t|
      t.string :content
      t.string :related_people
      t.datetime :deadline
      t.boolean :is_urgent

      t.timestamps
    end
  end
end
