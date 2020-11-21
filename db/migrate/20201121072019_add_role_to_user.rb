class AddRoleToUser < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :role, :integer, null: false, default: 0
  end
  def down
    remove_column :users, :role
  end
end