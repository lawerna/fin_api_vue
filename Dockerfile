FROM ruby:3.0.2 as base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs yarn

WORKDIR /app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /app

ARG DEFAULT_PORT 3000

EXPOSE ${DEFAULT_PORT}

CMD [ "bundle","exec", "puma", "config.ru"]
