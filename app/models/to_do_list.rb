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
  BG_COLOR_SELECTION = ["#F5B7B1", "#F2D7D5", "#F0B27A", "#FAD7A0", "#F9E79F", "#FFF1A4", "#A3E4D7", "#ABEBC6", "#85C1E9", "#AED6F1", "#EBDEF0", "#D7BDE2"]
  # TODO validates bg_color
  before_validation :set_bg_color, on: :create
  validates :user_id, presence: true
  validates :name, presence: true
  validates :bg_color, presence: true

  belongs_to :user
  has_many :items, -> { order(position: :asc) }, class_name: "ToDoItem", dependent: :destroy

  scope :today, ->{
      where('created_at >= :t1 AND created_at <= :t2',
      :t1=>Time.now.in_time_zone("Taipei").beginning_of_day,
      :t2=>Time.now.in_time_zone("Taipei").end_of_day
  )}


  def set_bg_color
    self.bg_color = BG_COLOR_SELECTION[(rand()*BG_COLOR_SELECTION.size).to_i]
  end
end
