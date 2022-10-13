FROM ruby:3.0.4-alpine3.16

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    SEXY_SETTINGS_DELIMITER=";" \
    CHROME_ARGS="window-size=1920x1080, disable-gpu, no-sandbox, disable-dev-shm-usage, disable-software-rasterizer"

RUN apk update && apk upgrade --no-cache --available \
    && apk add --no-cache \
      chromium firefox \
      chromium-chromedriver \
      ttf-freefont \
      font-noto-emoji \
      build-base bash \
      curl \
      git \
      less dbus \
    && apk add --no-cache \
      --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing font-wqy-zenhei \
    && wget https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz \
    && tar -zxf geckodriver-v0.31.0-linux64.tar.gz -C /usr/bin \
    && dbus-daemon --system

RUN adduser -D howitzer-user
USER howitzer-user

WORKDIR /home/howitzer_app

COPY --chown=howitzer-user Gemfile Gemfile.lock /home/howitzer_app/
RUN bundle config --global frozen 1 && bundle install --jobs=3 --retry=3

COPY --chown=howitzer-user . ./

ENTRYPOINT ["sleep", "infinity"]
