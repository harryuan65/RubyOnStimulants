class RemoveOldFieldCountOnArticle < ActiveRecord::Migration[6.0]
  # Violates rubocop bulk update
  # def up
  #   remove_column :articles, :comment_count
  #   remove_column :articles, :like_count
  # end

  # def down
  #   add_column :articles, :comment_count, :integer
  #   add_column :articles, :like_count, :integer
  # end
  def change
    reversible do |migration|
      migration.up do
        change_table :articles, bulk: true do |t|
          t.remove :comment_count
          t.remove :like_count
        end
      end

      migration.down do
        change_table :articles, bulk: true do |t|
          t.column :comment_count, :integer
          t.column :like_count, :integer
        end
      end
    end
  end
end
