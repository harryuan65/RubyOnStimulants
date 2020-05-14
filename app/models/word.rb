class Word < ApplicationRecord
  has_many :meanings
  has_many :examples
  validates :name, presence: true
  has_one :first_example, ->{ order('id desc').limit(1) }, class_name: 'Example'
end
