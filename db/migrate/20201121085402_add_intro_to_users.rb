class AddIntroToUsers < ActiveRecord::Migration[6.0]
  def change
    reversible do |migration|
      migration.up do
        execute(
        <<~SQL.squish
          ALTER TABLE users ADD COLUMN intro VARCHAR(128);
          UPDATE users
          SET intro='rails developer'
          WHERE email='#{ENV['ADMIN']}'
        SQL
      )
      end

      migration.down do
        execute(
          <<~SQL.squish
            ALTER TABLE users DROP COLUMN intro;
          SQL
        )
      end
    end
  end
end
