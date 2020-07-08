ARG RUBY_VERSION=2.7.1

#development

FROM ruby:$RUBY_VERSION-alpine as development

RUN apk add --no-cache \
  git build-base yarn nodejs postgresql-dev imagemagick-dev \
  chromium-chromedriver chromium tzdata \
  && rm -rf /var/cache/apk/*

ENV RAILS_ENV=development
ENV RACK_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8
ENV GEM_HOME=/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH=/app/bin:$BUNDLE_BIN:$PATH

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./

RUN gem install bundler \
  && bundle install -j "$(getconf _NPROCESSORS_ONLN)"  \
  && rm -rf $BUNDLE_PATH/cache/*.gem \
  && find $BUNDLE_PATH/gems/ -name "*.c" -delete \
  && find $BUNDLE_PATH/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-Cconfig/puma.rb"]

# production

FROM ruby:$RUBY_VERSION-alpine as production

RUN apk add --no-cache postgresql-dev imagemagick-dev nodejs yarn tzdata \
  && rm -rf /var/cache/apk/*

WORKDIR /app

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8
ENV GEM_HOME=/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH=/app/bin:$BUNDLE_BIN:$PATH
ENV SECRET_KEY_BASE=blah

COPY --from=development /bundle /bundle
COPY --from=development /app ./

RUN RAILS_ENV=production bundle exec rake assets:precompile

RUN rm -rf node_modules tmp/* log/* app/assets vendor/assets lib/assets test \ 
  && yarn cache clean

RUN apk del yarn

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-Cconfig/puma.rb"]
