desc "This task is called by the Heroku scheduler add-on"
task :poke => :environment do
  res = RestClient.get "https://harrysworkspace.herokuapp.com/"
  puts "Poke: #{res.code}"
end

# task :send_reminders => :environment do
#   User.send_reminders
# end