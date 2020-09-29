class AddOmniauthToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :fb_uid
      t.string :fb_token
      t.string :google_uid
      t.string :google_token
    end
    # Was
    # add_column :users, :fb_uid, :string
    # add_column :users, :fb_token, :string
    # add_column :users, :google_uid, :string
    # add_column :users, :google_token, :string
  end
end
