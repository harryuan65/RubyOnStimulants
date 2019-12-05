
if Rails.env.development?
    options = {
      hosts: [
        {
          login: "admin",
          passcode: "admin",
          host: "localhost",
          port: 61613,
          ssl: false
        }
      ]
    }
    #用之前要開activemq
    # $stomp = Stomp::Client.new(options)
    # puts "~~~~StompSuccess~~~~~"
    # $stomp.publish("/queue/emit_event",{foo:"bar"}.to_json)
    # $stomp.subscribe("/queue/emit_event") do |msg|
    #     puts JSON.parse(msg.body)
    # end
  end
