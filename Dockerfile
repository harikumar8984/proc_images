FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /prog_image
WORKDIR /prog_image
COPY Gemfile /prog_image/Gemfile
COPY Gemfile.lock /prog_image/Gemfile.lock
RUN bundle install
COPY . /prog_image

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
