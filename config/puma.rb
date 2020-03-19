# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
workers 1
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port        ENV.fetch("PORT") { 3005 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

on_worker_boot do
  t = Thread.new do
    puts "[Wakeup]Started counter"
    next_poke_time = (Time.now.utc.localtime("+08:00") + 30.minutes)
    while true
      begin
        sleep(1)
        if Time.now.utc.localtime("+08:00").strftime("%k:%M:%S") == next_poke_time.strftime("%k:%M:%S")
          res = RestClient.get 'http://localhost:3005'
          next_poke_time = (Time.now.utc.localtime("+08:00") + 30.minutes)
          puts res.code==200? "Wake success, next poke starting at #{next_poke_time.strftime("%k:%M:%S")}" : "Wake failed"
        end
      rescue SystemExit, Interrupt
        puts "關閉中"
        t.join
      end
    end
  end
end