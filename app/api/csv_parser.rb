require 'csv'
require_relative './global.rb'
module CSVParser
    def createhash row, avoid_nil #(array) row = [["name", "jack"],["goognight_user_id"],["ip", "223.140.238.128"], ["intro", nil], ["id", "2941471"] ,["email", "o8q4@yahoo.com.tw"], ["google_email", nil], ["device_platform", "iOS"]]
      if avoid_nil
        row = row.select{
          |d| d[1]!=nil
        }
      end
      r =  Hash[
            row.each do |d|
              [d[0],d[1]]
            end
        ]
        return r
    end

    def read_hash_from io,avoid_nil
        puts("[CSVParser]Loading hash from csv...")
        data = []
        file_path = File.join(Global::CSV_UPLOAD_PATH,io.to_s)
        path = (File.exists?(file_path)? Global::CSV_UPLOAD_PATH : Global::CSV_EXPORT_PATH)
        Dir.chdir(path) do
          print(' ')
          puts(file_path)
          CSV.foreach(io,headers: true) do |row|
            hsh = createhash row, avoid_nil
            data.push(hsh)
          end
        end
        return data
    end

    def check_exports
        if !File.exists?(Global::CSV_EXPORT_PATH)
          puts("[CSVParser]Detected export does not exist. Creating.")
          Dir.mkdir(Global::CSV_EXPORT_PATH)
          puts("[CSVParser]Created")
        end
    end

    def export_africa hash_arr,file_name
        check_exports
        Dir.chdir(Global::CSV_EXPORT_PATH) do
          fn = file_name.split('.')[0]+'_' + DateTime.now.in_time_zone('Taipei').strftime("%m-%d_%H-%M") +'.csv'
          CSV.open(fn,'w') do |row|
            row << hash_arr[0].keys
            hash_arr.each do |hash|
              row<<hash.values
            end
          end
          return fn
        end
    end
end