FROM ruby:2.6.5
RUN apt-get update -qq && apt-get upgrade -y
RUN apt-get install -y build-essential nodejs && apt-get clean
RUN gem install foreman

ENV GOVUK_APP_NAME collections
ENV PORT 3070
ENV RAILS_ENV development

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
ADD .ruby-version $APP_HOME/
RUN bundle install

ADD . $APP_HOME

RUN GOVUK_APP_DOMAIN=www.gov.uk GOVUK_WEBSITE_ROOT=http://www.gov.uk RAILS_ENV=production bundle exec rails assets:precompile

CMD foreman run web
