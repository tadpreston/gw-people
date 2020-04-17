FROM ruby:2.7.1-slim-buster

MAINTAINER Tad Preston <tad.preston@gatewaystaff.com>

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev git

ENV RAILS_ROOT /var/www/gw-people
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --binstubs

COPY . .

VOLUME ["$RAILS_ROOT/public"]

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
