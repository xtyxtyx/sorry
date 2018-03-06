FROM ruby
ADD ./ /app
WORKDIR /app
RUN apt-get update && apt-get install -y locales locales-all ttf-wqy-microhei ffmpeg && \
    bundle install
CMD ruby src/sorry.rb
