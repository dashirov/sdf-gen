FROM ruby

ENV DIR /backend
ENV RACK_ENV production
RUN mkdir $DIR
WORKDIR $DIR
ADD . $DIR
RUN bundle install

EXPOSE 4567

CMD ["ruby", "backend.rb"]