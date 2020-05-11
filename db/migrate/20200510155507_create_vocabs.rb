class CreateVocabs < ActiveRecord::Migration[5.2]
  def change
    create_table :vocabs do |t|
      t.string :word
      t.string :meaning

      t.timestamps
    end
  end
end
