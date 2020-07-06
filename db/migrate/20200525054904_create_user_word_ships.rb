class CreateUserWordShips < ActiveRecord::Migration[5.2]
  def change
    create_table :user_word_ships do |t|
      t.integer :user_id
      t.integer :word_id
      t.timestamps
    end
  end
end
