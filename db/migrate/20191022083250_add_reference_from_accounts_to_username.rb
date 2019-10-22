class AddReferenceFromAccountsToUsername < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts,:user, index:true
  end
end
