web: bundle exec rails db:migrate && bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-production}
worker: bundle exec sidekiq -t 25