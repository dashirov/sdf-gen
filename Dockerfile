FROM ruby:2.0
MAINTAINER Conjur Inc

WORKDIR /

ADD . /opt/
RUN cd /opt && bundle install

ENTRYPOINT ["sdf-gen"]
