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

EXPOSE 3000
CMD ["/usr/bin/bash"]