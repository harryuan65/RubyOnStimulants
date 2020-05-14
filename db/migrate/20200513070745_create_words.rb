class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :words, :name, unique: true

    create_table :meanings do |t|
      t.references :word
      t.string :mean, null: false
      t.string :mean_en, null: false
      t.string :part_of_speech, null: false
    end
    add_index :meanings, :mean
    add_index :meanings, :part_of_speech
    add_index :meanings, [:word_id, :part_of_speech], unique: true

    create_table :examples do |t|
      t.references :word, index: true
      t.references :meaning, index: true
      t.string :sentence, null: false
      t.string :translation, null: false
      t.timestamps
    end
    add_index :examples, [:word_id,:meaning_id]

  end
end
