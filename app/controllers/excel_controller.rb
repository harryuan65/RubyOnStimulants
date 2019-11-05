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
        @data = read_hash_from @file_name, false
        @longest_hash = @data.max_by(&:length)
      rescue=>exception
        flash[:alert] = exception.to_s
        render 'shared/result',locals:{status:false, message:"抱歉，把下面的貼給我",error: exception.to_s}
      end
    end

    def processed_csv
      # begin
        @file_name = params[:file_io]
        @data = read_hash_from @file_name, false
        @longest_hash = @data.max_by(&:length)
        @africa = africa_arr
        @matched = filter_af @data

       puts "New Data size= #{@matched.size}"
      # rescue=>exception
      #   flash[:alert] = exception.to_s
      #   render 'shared/result',locals:{status:false, message:"抱歉，把下面的貼給我",error: exception.to_s}
      # end
    end

    def export_filter_africa
      # begin
        @file_name = params[:file_io]
        @data = read_hash_from @file_name, false
        @longest_hash = @data.max_by(&:length)
        @africa = africa_arr
        @matched = filter_af @data

        filename = export_africa @matched, params[:file_io]
        flash[:notice] = "成功輸出了 #{filename}"
        redirect_to action:'index'
      # rescue=>exception
        # return render 'shared/result',locals:{status:false, message:"抱歉他怪怪的，把下面的貼給我",error: exception.to_s}
      # end
    end

    def filter_af data
      final_arr = []
      data.each do |hash|
        if africa_arr().include?(hash["country"])
          final_arr.push(hash)
        end
      end
      return final_arr
    end

    def match_hash #建一個空的 [{key=>false}]
      af_hash = Hash.new
      count = 0
      africa_arr().each do |country|
        af_hash["#{country}"] =false
        count+=1
        puts "#{count} "+af_hash["#{country}"].to_s
      end
      return af_hash
    end

    def show_hash this
      this.each do |k,v|
        puts "#{k} #{v}"
      end
    end

    def africa_arr
    [ "Angola",
      "Burundi",
      "Benin",
      "Burkina Faso",
      "Botswana",
      "Central African Republic",
      # "Côte d'Ivoire",
      "Ivoire",
      "Cameroon",
      "Democratic Republic of the Congo",
      "Republic of the Congo",
      "Comoros",
      "Cape Verde",
      "Djibouti",
      "Algeria",
      "Egypt",
      "Eritrea",
      "Western Sahara",
      "Ethiopia",
      "Gabon",
      "Ghana",
      "Guinea",
      "The Gambia",
      "Guinea-Bissau",
      "Equatorial Guinea",
      "Kenya",
      "Liberia",
      "Libya",
      "Lesotho",
      "Morocco",
      "Madagascar",
      "Mali",
      "Mozambique",
      "Mauritania",
      "Mauritius",
      "Malawi",
      "Mayotte",
      "Namibia",
      "Niger",
      "Nigeria",
      # "Réunion",
      "Reunion",
      "Rwanda",
      "Sudan",
      "Senegal",
      "Sierra Leone",
      "Somalia",
      "South Sudan",
      # "São Tomé and Príncipe",
      "Sao Tome and Principe",
      "Swaziland(Eswatini)",
      "Seychelles",
      "Chad",
      "Togo",
      "Tunisia",
      "Tanzania",
      "Uganda",
      "South Africa",
      "Zambia",
      "Zimbabwe",
    ]
    end

end