FROM ruby:3.1

COPY Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends\
    $(grep -Ev '^\s*#' /tmp/Aptfile | xargs)\
    && apt-get clean\
    && rm -rf /var/cache/apt/archives/*\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*\
    && truncate -s 0 /var/log/*log

ENV LANG=C.UTF-8\
  BUNDLE_JOBS=4\
  BUNDLE_RETRY=3

ENV BUNDLE_APP_CONFIG=.bundle
RUN gem update --system &&\
    gem install bundler

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config --local deployment 'true' \
 && bundle config --local without 'development test' \
 && bundle config --local clean 'true' \
 && bundle config --local no-cache 'true' \
 && bundle install \
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . .

RUN mkdir -p log tmp/pids tmp/storage

EXPOSE 3000
CMD bundle exec rails server -b 0.0.0.0