class CreateOnbLineUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :onb_line_users do |t|
      t.string :line_uid
      t.string :display_name
      t.string :picture_url
      t.string :status_message
      t.string :language
      t.boolean :archived, default: false
      t.datetime :blocked_channel_at
      t.timestamps
    end
    add_index :onb_line_users, :line_uid, unique: true
  end
end
