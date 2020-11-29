desc "This task is called by the Heroku scheduler add-on"
task :poke => :environment do
  res = RestClient.get "https://activemine.herokuapp.com/"
  puts "Poke: #{res.code}"
end

task :shell_hello do
  sh "echo 'hello'"
end