# == Schema Information
#
# Table name: examples
#
#  id          :bigint           not null, primary key
#  word_id     :bigint
#  meaning_id  :bigint
#  sentence    :string           not null
#  translation :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Example < ApplicationRecord
  belongs_to :word
  belongs_to :definition
end
