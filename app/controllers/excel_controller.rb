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
          # redirect_to action:'show_csv', file_io:uploaded_io.original_filename
        rescue=>exception
            puts(exception)
        end
    end

    def show_csv
      begin
        @file_name = params[:file_io]
        @data = read_hash_from @file_name, false
        # @data.each do |hash|
        #   puts hash
        # end
        @longest_hash = @data.max_by(&:length)
      rescue=>exception
        flash[:alert] = exception.to_s
        render 'shared/result',locals:{status:false, message:"抱歉姆咪他怪怪的，把下面的貼給姆姆",error: exception.to_s}
      end
    end

    def processed_csv
      begin
        @file_name = params[:file_io]
        @africa_names = read_hash_from "0_非洲國家_直.csv",true
        @africa_arr = []
        @africa_names.each do |row|
          row.each do |k,v|
            @africa_arr.push(v)
          end
        end
        @data = read_hash_from @file_name, false
        @longest_hash = @data.max_by(&:length)
        country = @longest_hash['country']? "country" : "Country"
        puts @longest_hash
        @data = @data.select{ |hash| @africa_arr.include?(hash["#{country}"])}
      rescue=>exception
        flash[:alert] = exception.to_s
        render 'shared/result',locals:{status:false, message:"抱歉姆咪他怪怪的，把下面的貼給姆姆",error: exception.to_s}
      end
    end

    def export_filter_africa
      begin
        @africa_names = read_hash_from "0_非洲國家_直.csv",true
        @africa_arr = []
        @africa_names.each do |row|
          row.each do |k,v|
            @africa_arr.push(v)
          end
        end
        @data = read_hash_from params[:file_name], true
        @longest_hash = @data.max_by(&:length)
        country = @longest_hash['country']? "country": "Country"
        puts "country ===>  #{country} :#{@data.size}"
        @data = @data.select{ |hash| @africa_arr.include?(hash["#{country}"])}

        filename = export_africa @data, params[:file_name]
        flash[:notice] = "Successfully output #{filename}"
        redirect_to action:'index'
      rescue=>exception
        return render 'shared/result',locals:{status:false, message:"抱歉姆咪他怪怪的，把下面的貼給姆姆",error: exception.to_s}
      end
    end
end