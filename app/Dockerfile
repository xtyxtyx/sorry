FROM ubuntu:bionic

ADD ./Gemfile /app/
WORKDIR /app

# 使用国内清华源加快apt速度
COPY ./sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y \
  locales \
  locales-all \
  ttf-wqy-microhei \
  ffmpeg \
  cron \
  build-essential \
  ruby-dev

# 使用国内Gem镜像
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN gem install bundler
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
RUN bundle install

ADD ./ /app

# 定时任务
RUN crontab cron-sorry
CMD cron && ruby src/sorry.rb
