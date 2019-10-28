class ExcelController < ApplicationController
    def index
      @uploads = []
      Dir.new(Global::CSV_UPLOAD_PATH).each do |file|
        if file.end_with?(".csv")
          @uploads.push(file)
        end
      end

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
        begin
          File.open(Rails.root.join(Global::CSV_UPLOAD_PATH, uploaded_io.original_filename), 'wb') do |file|
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
      @file_name = params[:file_io]
      @africa_names = read_hash_from "非洲國家_直.csv",true
      @africa_arr = []
      @africa_names.each do |row|
        row.each do |k,v|
          @africa_arr.push(v)
        end
      end
      @data = read_hash_from @file_name, true
      @data.each do |d|
        puts d
      end
      country = @data[0]['country']? 'country' : 'Country'
      @data = @data.select{ |hash| @africa_arr.include?(hash["#{country}"])}
    end

    def export_filter_africa
      begin
        @africa_names = read_hash_from "非洲國家_直.csv",true
        @africa_arr = []
        @africa_names.each do |row|
          row.each do |k,v|
            @africa_arr.push(v)
          end
        end
        @data = read_hash_from params[:file_name], true
        @data = @data.select{ |hash| @africa_arr.include?(hash['country'])}
        filename = export_africa @data, params[:file_name]
        flash[:notice] = "Successfully output #{filename}"
        redirect_to action:'index'
      rescue=>exception
        return render json:{err:exception}
      end
    end
end