class Meaning < ApplicationRecord
  belongs_to :word
  has_many :examples
  validates :part_of_speech, acceptance: { accept: ['n', 'v', 'adj', 'adv', 'prep', 'pron', 'interj', 'conj'] }
end