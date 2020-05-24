class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :words, :name, unique: true

    create_table :definitions do |t|
      t.references :word
      t.string :def_org, null: false
      t.string :tag
      t.string :zh_tw_translation, null: false
      t.string :part_of_speech, null: false
      t.timestamps
    end
    add_index :definitions, :def_org
    add_index :definitions, :part_of_speech
    add_index :definitions, [:word_id, :def_org, :zh_tw_translation, :part_of_speech], unique: true, name: "index_on_definition_fields"

    create_table :examples do |t|
      t.references :word, index: true
      t.references :definition, index: true
      t.string :sentence, null: false
      t.string :translation, null: false
      t.timestamps
    end
    add_index :examples, [:word_id, :definition_id]

  end
end
