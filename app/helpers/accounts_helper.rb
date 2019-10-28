module AccountsHelper
    def taipei_time time
        time.in_time_zone("Taipei").strftime("%m/%d %k:%M")
    end
end
