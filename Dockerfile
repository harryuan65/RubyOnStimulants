FROM ruby:2.7.2-slim
RUN apt-get update && apt-get -y install curl libpq-dev build-essential patch ruby-dev zlib1g-dev liblzma-dev libcurl4-openssl-dev
RUN apt autoremove && apt clean
ENV RAILS_ROOT /var/www/rails

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

COPY . .
ENTRYPOINT ["bundle", "exec", "rails", "s", "-p", "$PORT"]
