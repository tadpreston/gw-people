FROM ruby:2.7.1

MAINTAINER Tad Preston <tad.preston@gatewaystaff.com>

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn libpq-dev git

ENV RAILS_ROOT /var/www/gw-people
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --binstubs

COPY . .

VOLUME ["$RAILS_ROOT/public"]

RUN yarn install --check-files

ENV DATABASE_URL postgresql://user:pass@127.0.0.1/dbname?
ENV RAILS_ENV production
RUN bundle exec rake assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
