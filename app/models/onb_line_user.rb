class OnbLineUser < ApplicationRecord
  validates_presence_of :line_uid
  validates_presence_of :display_name
  validates_uniqueness_of :user_id
end
