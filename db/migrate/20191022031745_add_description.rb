class AddDescription < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts,:description, :string
  end
end
