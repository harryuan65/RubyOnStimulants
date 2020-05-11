module ApplicationHelper
    def taipei_time time
        time.in_time_zone("Taipei")
    end
end
