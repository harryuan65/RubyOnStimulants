module AccountsHelper
    def taipei_time time
        time.in_time_zone("Taipei").strftime("%Y/%m/%d %k:%M %p")
    end
end
