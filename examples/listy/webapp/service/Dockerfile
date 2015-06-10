FROM ruby

ENV DIR /webapp
ENV RACK_ENV production
RUN mkdir $DIR
WORKDIR $DIR
ADD . $DIR
RUN bundle install

EXPOSE 4567

CMD ["ruby", "webapp.rb"]
