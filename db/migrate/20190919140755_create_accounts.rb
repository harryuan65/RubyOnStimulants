class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :currency
      t.integer :price
      t.string :content
      t.string :category

      t.timestamps
    end
  end
end
