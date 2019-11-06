class ExcelController < ApplicationController
    def index
      @uploads = []
      Dir.new(Global::CSV_UPLOAD_PATH).each do |file|
        if file.end_with?(".csv")
          @uploads.push(file)
        end
      end
      @uploads= @uploads.sort_by{|str| str.split('_')[0].to_i}

      @exports=[]
      check_exports
      Dir.new(Global::CSV_EXPORT_PATH).each do |file|
        if file.end_with?(".csv")
          @exports.push(file)
        end
      end
      @exports = @exports.sort_by{|str| str.split('_')[0].to_i}

    end

    def upload
        uploaded_io = params[:csv_file]
        @uploads = []
        Dir.new(Global::CSV_UPLOAD_PATH).each do |file|
          if file.end_with?(".csv")
            @uploads.push(file)
          end
        end
        begin
          File.open(Rails.root.join(Global::CSV_UPLOAD_PATH, @uploads.size.to_s+"_"+uploaded_io.original_filename.gsub(' ','_')), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          puts("Uploaded "+uploaded_io.original_filename)
          redirect_to action:'index'
        rescue=>exception
            puts(exception)
        end
    end

    def show_csv
      begin
        @file_name = params[:file_io]
        @file_path = get_full_csv_path @file_name
        @hash_arr = read_hash_from @file_name, false
        @longest_hash = @hash_arr.max_by(&:length)
        # @hash_arr = @hash_arr.delete_if{|hash| hash[:country]=="Papua New Guinea" } 這是array of hash 可以用
        @hash_arr = @hash_arr.delete_if{|hash| hash["country"]=="Papua New Guinea"}
      rescue=>exception
        flash[:alert] = exception.to_s
        render 'shared/result',locals:{status:false, message:"抱歉，把下面的貼給我",error: exception.to_s}
      end
    end

    def processed_csv
      # begin
        @file_name = params[:file_io]
        @hash_arr = read_hash_from @file_name, false
        @africa = africa_arr
        @matched = filter_af @hash_arr
        @longest_hash = @matched.max_by(&:length)

        @missing = find_missing @matched
        @matched = fill_empty @matched
        @matched = @matched.sort_by{|hash| hash["country_code"]}
      # rescue=>exception
      #   flash[:alert] = exception.to_s
      #   render 'shared/result',locals:{status:false, message:"抱歉，把下面的貼給我",error: exception.to_s}
      # end
    end

    def export_filter_africa
      # begin
        @file_name = params[:file_io]
        @hash_arr = read_hash_from @file_name, false
        @africa = africa_arr
        @matched = filter_af @hash_arr
        @longest_hash = @matched.max_by(&:length)

        @matched = fill_empty @matched

        @matched = @matched.sort_by{|hash| hash["country_code"]}
        filename = export_africa @matched, params[:file_io]
        flash[:notice] = "成功輸出了 #{filename}"
        redirect_to action:'index'
      # rescue=>exception
        # return render 'shared/result',locals:{status:false, message:"抱歉他怪怪的，把下面的貼給我",error: exception.to_s}
      # end
    end

    def filter_af hash_arr
      final_arr = []
      hash_arr.each do |hash|
        africa_arr().each do |countryItem|
          if /#{countryItem[0]}/.match(hash["country"])
            hash["country_code"] = countryItem[1]
            new_hash = {:no=>countryItem[2]}.merge(hash)
            final_arr.push(new_hash)
            break
          end
        end
      end
      final_arr = final_arr.delete_if{|hash| hash["country"]=="Papua New Guinea" }
      return final_arr
    end

    def find_missing hash_arr
      recording = Hash.new
      missing = []
      africa_arr().each do |pair|
        recording["#{pair[1]}"] = false
      end
      hash_arr.each do |hash|
        recording["#{hash["country_code"]}"]=true
      end
      africa_hashes = africa_arr().map{
        |e|
        [e[0],e[1]]
      }.to_h.invert
      recording.each do |k,v|
        if !v
          missing.push(africa_hashes["#{k}"].gsub('.*',' '))
        end
      end
      # puts '============================'
      # puts missing
      # puts '============================'
      return missing.sort
    end

    def fill_empty hash_arr
      current_codes = hash_arr.map{|hash| hash["country_code"]}
      africa_arr().each do |e|
        if !current_codes.include?(e[1])
          hash = {"no"=>e[2], "country"=>e[0].gsub('.*',' '), "country_code"=>e[1],"empty"=>"這個資料沒有這個國家"}
          hash_arr.push(hash)
          puts hash
        end
      end
      return hash_arr
    end

    def africa_arr
    [ ["Angola","AGO",1],
      ["Burundi","BDI",2],
      ["Benin","BEN",3],
      ["Burkina.*Faso","BFA",4],
      ["Botswana","BWA",5],
      ["Central.*African.*Republic","CAF",6],
      ["Ivoire","CIV",7],
      ["Cameroon","CMR",8],
      [".*Congo.*Dem.*","COD",9],
      ["Congo","COG",10],
      ["Comoros","COM",11],
      ["Cape.*Verde","CPV",12],
      ["Djibouti","DJI",13],
      ["Algeria","DZA",14],
      ["Egypt","EGY",15],
      ["Eritrea","ERI",16],
      ["Ethiopia","ETH",17],
      ["Gabon","GAB",18],
      ["Ghana","GHA",19],
      ["Guinea","GIN",20],
      ["Gambia","GMB",21],
      ["Guinea.*Bissau","GNB",22],
      ["Equatorial.*Guinea","GNQ",23],
      ["Kenya","KEN",24],
      ["Liberia","LBR",25],
      ["Libya","LBY",26],
      ["Lesotho","LSO",27],
      ["Morocco","MAR",28],
      ["Madagascar","MDG",28],
      ["Mali","MLI",30],
      ["Mozambique","MOZ",31],
      ["Mauritania","MRT",32],
      ["Mauritius","MUS",33],
      ["Malawi","MWI",34],
      ["Namibia","NAM",35],
      ["Niger","NER",36],
      ["Nigeria","NGA",37],
      ["Rwanda","RWA",38],
      ["Sudan","SDN",39],
      ["Senegal","SEN",40],
      ["Sierra.*Leone","SLE",41],
      ["Somalia","SOM",42],
      ["South.*Sudan","SSD",43],
      [".*Sao.*Tome.*Principe.*","STP",44],
      ["Swaziland","SWZ",45],
      ["Eswatini","SWZ",45],
      ["Seychelles","SYC",46],
      ["Chad","TCD",47],
      ["Togo","TGO",48],
      ["Tunisia","TUN",49],
      ["Tanzania","TZA",50],
      ["Uganda","UGA",51],
      ["South.*Africa","ZAF",52],
      ["Zambia","ZMB",53],
      ["Zimbabwe","ZWE",54]
    ].sort_by{|element| element[0].length}.reverse
    end

end