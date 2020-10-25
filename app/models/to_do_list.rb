# == Schema Information
#
# Table name: to_do_lists
#
#  id         :bigint           not null, primary key
#  thing      :string
#  done       :boolean
#  postscript :string
#  deadline   :datetime
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ToDoList < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: "ToDoItem"
  scope :today, ->{
      where('created_at >= :t1 AND created_at <= :t2',
      :t1=>Time.now.in_time_zone("Taipei").beginning_of_day,
      :t2=>Time.now.in_time_zone("Taipei").end_of_day
  )}
end
