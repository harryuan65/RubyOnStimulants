# == Schema Information
#
# Table name: meanings
#
#  id             :bigint           not null, primary key
#  word_id        :bigint
#  mean           :string           not null
#  mean_en        :string           not null
#  part_of_speech :string           not null
#

class Definition < ApplicationRecord
  belongs_to :word
  has_many :examples
  has_one :first_example, ->{ order(id: :asc).limit(1) }, class_name: 'Example'
  validates :part_of_speech, acceptance: { accept: ['noun', 'verb', 'adjective', 'adverb', 'preposition', 'pronoun', 'interjection', 'conjunction','exclamation', 'suffix'] }
end
