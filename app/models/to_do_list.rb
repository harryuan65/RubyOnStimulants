class ToDoList < ApplicationRecord
    belongs_to :user
    scope :today, ->{
        where('created_at >= :t1 AND created_at <= :t2',
        :t1=>Time.now.in_time_zone("Taipei").beginning_of_day,
        :t2=>Time.now.in_time_zone("Taipei").end_of_day
    )}
end
