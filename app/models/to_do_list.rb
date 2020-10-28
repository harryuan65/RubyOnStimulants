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
  BG_COLOR_SELECTION = ["rgb(255, 241, 164)", "#daf7a6", "#F0B27A", "#AED6F1", "#F5B7B1"]
  # TODO validates bg_color
  belongs_to :user
  has_many :items, -> { order(position: :asc) }, class_name: "ToDoItem", dependent: :destroy

  scope :today, ->{
      where('created_at >= :t1 AND created_at <= :t2',
      :t1=>Time.now.in_time_zone("Taipei").beginning_of_day,
      :t2=>Time.now.in_time_zone("Taipei").end_of_day
  )}

  after_commit :set_bg_color, on: :create

  def set_bg_color
    self.update!(bg_color: BG_COLOR_SELECTION[self.id%BG_COLOR_SELECTION.size])
  end
end
