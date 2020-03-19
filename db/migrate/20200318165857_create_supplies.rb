class CreateSupplies < ActiveRecord::Migration[5.2]
  def change
    create_table :supplies do |t|
      t.string :name
      t.integer :category
      t.integer :quantity
      t.datetime :earliest_expiration

      t.timestamps
    end
  end
end
