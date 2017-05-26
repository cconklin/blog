FROM ruby:2.3.1
RUN echo 'LC_ALL="en_US.UTF-8"' > /etc/default/locale
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES 1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libxml2 libxml2-dev libxslt1-dev 
RUN mkdir /blog
WORKDIR /blog
ADD Gemfile /blog/Gemfile
ADD Gemfile.lock /blog/Gemfile.lock
RUN gem install bundler
RUN bundle install
ADD . ./blog
