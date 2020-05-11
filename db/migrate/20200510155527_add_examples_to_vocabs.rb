class AddExamplesToVocabs < ActiveRecord::Migration[5.2]
  def change
    add_column :vocabs, :examples, :text, array:true, default: []
  end
end
