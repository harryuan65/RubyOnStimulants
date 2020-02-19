require 'rest-client'

class HomeController < ApplicationController
    protect_from_forgery with: :null_session
    def index
      # binding.pry
    end

    def post_newrecord
        begin
          res = RestClient.post "http://localhost:3000/update_records/new_record", {
            :update_record=>{
            :goodnight_user_id=>'1',
            :name=> 'harry yuan',
            :ip=> '121.49.35.15',
            :intro=>'Goodnight intern',
            :locale=>'zh-TW',
            :email=> '',
            :google_email=> 'harryuan@gmail.com',
            :device_platform=>'android'
          }}.to_json, {content_type: :json, accept: :json}
          data = JSON.parse(res.body)
          case res.code
          when 201
            render 'shared/result',locals:{status: true, message:"(POST)Created",data: data}
          when 200
            render 'shared/result',locals:{status: true,message:"(GET)Created" ,data:data}
          when 401
            render 'shared/result',locals:{status: false,message:"Unauthorized"}
          else
            render 'shared/result',locals:{status: false,error: "Failed"}
          end
        rescue => exception
          render 'shared/result',locals:{status: false,error: exception}
        end

        def list_home

        end
    end

    def yeah
    end

    def list_home
      @data = []
      50.times.each do |d|
        @data.push({
          id: Faker::IDNumber.brazilian_id,
          name: Faker::Name.unique.name,
          email: Faker::Internet.email,
          gender:Faker::Gender.binary_type
        })
      end
      @data
    end

    def post_list
      return render 'shared/result',locals:{status:true,message:"success",data:params}
    end

    def webhook
       return render json:{message:"webhook"}, status: 200
    end
end