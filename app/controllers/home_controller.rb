require 'rest-client'

class HomeController < ApplicationController
  protect_from_forgery with: :null_session
  def index
  end

  def news
    @news_list = news_list
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
  end

  def yeah
  end

  def domain_auth
    @htmldoc = File.read('google3e784468cd0fd9bb.html.txt')
    render html: @htmldoc
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
    return render json:{message:"webhook"}, status: :ok
  end

  def privacy_policy
  end

  private
  def news_list
    [
      {
        title: "Rename site to ActiveMine and implement new theme layout and style",
        description: "took me 3 days",
        date: "Nov 15, 2020"
      },
      {
        title: "Reanimate To do list",
        description: "fix a lot of logic for to do list",
        date: "Nov 1, 2020"
      },
      {
        title: "Introduce Rspec for to do list/items",
        description: "feat: install rspec",
        date: "Oct 29, 2020"
      },
      {
        title: "Switch category field to tags for articles",
        description: "feat: gutentag",
        date: "Oct 26, 2020"
      },
      {
        title: "Working todolist version1 with SJR",
        description: "feat: using SJR",
        date: "Oct 26, 2020"
      },
      {
        title: "Add new todo list animation",
        description: "feat: replot animation",
        date: "Oct 26, 2020"
      },
      {
        title: "Adjust article container structure",
        description: "feat: adjust article container",
        date: "Oct 25, 2020"
      },
      {
        title: "Implement to do list mockup into rails",
        description: "feat: view, controller, routes, blablabla...",
        date: "Oct 25, 2020"
      },
      {
        title: "Add jQuery in to do list mockup",
        description: "feat: jquery ui",
        date: "Oct 24, 2020"
      },
      {
        title: "Finish working to do list prototype",
        description: "feat: pure html/css/javascript",
        date: "Oct 24, 2020"
      },
      {
        title: "Recreate To-do list, update markdown parser helper",
        description: "feat: drop and create with new fields",
        date: "Oct 23, 2020"
      },
      {
        title: "Add private state for article, update UI state style",
        description: "feat: Update state in articles new and edit",
        date: "Oct 18, 2020"
      },
      {
        title: "Add private state for article, update UI state style",
        description: "feat: Update state in articles new and edit",
        date: "Oct 18, 2020"
      },
      {
        title: "Set \"order by\" in articles index",
        description: "feat: order article by id desc",
        date: "Oct 14, 2020"
      },
      {
        title: "Feature: Re-expose WordBook functionality",
        description: "feat: activate words again with new style",
        date: "Oct 14, 2020"
      },
      {
        title: "Switch from showing part of the content to subtitle",
        description: "feat: use subtitle in articles list",
        date: "Oct 14, 2020"
      },
      {
        title: "Feature: Expose ColorPicker",
        description: "feat: expose color picker, about me link",
        date: "Oct 8, 2020"
      },
      {
        title: "Markdown style and call method",
        description: "feat: generalize markdown, change pre inline code style",
        date: "Oct 1 ,2020"
      },
      {
        title: "Reset root path",
        description: "feat: make article#index as root path",
        date: "Oct 8, 2020"
      },
      {
        title: "hljs",
        description: "refactor: load hljs generally in layout",
        date: "Oct 8, 2020"
      },
      {
        title: "Update style",
        description: "feat: use noto sans light for pre/fix: hljs style in articles#new",
        date: "Oct 7, 2020"
      },
      {
        title: "Fix hjls not loading properly",
        description: "fix: hljs in articles#new",
        date: "Oct 7, 2020"
      },
      {
        title: "add hight in article show",
        description: "fix: article show hightlight",
        date: "Oct 4, 2020"
      },
      {
        title: "Change hljs style for code blocks",
        description: "feat: use tommorow night",
        date: "Oct 3, 2020"
      },
      {
        title: "Feature: add hljs to hightlight code blocks",
        description: "feat: add hightlight js, adjust style, add confirm leaving on edit page",
        date: "Oct 3, 2020"
      },
      {
        title: "Add confirm sign-out, and changed some style",
        description: "feat: redo some style, adjust style, add confirm sign-out",
        date: "Oct 3, 2020"
      },
      {
        title: "Remove fat fonts",
        description: "feat: remove cjktc font to reduce project size",
        date: "Sep 3,02020"
      },
     {
        title: "feat: Changed some styles",
        description: "Change container margin top to 0, and overflow scroll",
        date: "Oct 14, 2020"
      },
      {
        title: "feat: Changed some styles",
        description: "Change container margin top to 0, and overflow scroll",
        date: "Sep 2,62020"
      },
      {
        title: "feat: Markdown Preview for Articles",
        description: "Add markdown PREVIEW support in articles#edit/show",
        date: "Sep 2,02020"
      },
      {
        title: "Feat: Markdown Support for Articles",
        description: "Integrated redcarpet gem",
        date: "Sep 1,92020"
      },
      {
        title: "Feat: Article Edit Page",
        description: "Article edit page in rails",
        date: "Sep 1,82020"
      },
      {
        title: "Feat: Add article edit page mockup",
        description: "Dev using html/scss/js",
        date: "Sep 1,72020"
      },
      {
        title: "refactor: Stylesheets",
        description: "Rename some style files/css class names",
        date: "Sep 1,62020"
      },
      {
        title: "feat: Add article show page",
        description: "View/Controller",
        date: "Sep 1,52020"
      },
      {
        title: "feat: Create side nav bar",
        description: "As well as its transition using js",
        date: "Sep 14, 2020"
      },
      {
        title: "feat: Home page in rails",
        description: "Implement mockup into rails: home page",
        date: "Sep 1,32020"
      },
      {
        title: "Update: Mon, 05 Sep 2020",
        description: "Change all style into a new theme! Finally it’s here.",
        date: "Sep 0,52020"
      },
      {
        title: "feat: Add word card",
        description: "Model/View/Controller",
        date: "May 14, 2020"
      },
      {
        title: "New theme!",
        description: "Change all style into a new theme! Finally it’s here.",
        date: "Jan 19, 2020"
      },
      {
        title: "harrysworkspace",
        description: "Day of site creation.",
        date: "Oct 19, 2019"
      }
    ]
  end
end