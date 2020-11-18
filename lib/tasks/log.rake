task :log => :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
# use with bundle exec rails log db:migrate to view logs