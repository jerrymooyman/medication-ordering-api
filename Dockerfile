FROM mhart/alpine-node-auto:6.9.5

# Temp fix for https://bugs.alpinelinux.org/issues/6748
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories;

RUN apk add --update \
    "vim<8" \
    "jq<2" \
    "curl<8" \
    "bash<5" \
  && rm -rf /var/cache/apk/*

#Install yarn
RUN mkdir -p /opt && \
  curl -sL https://github.com/yarnpkg/yarn/releases/download/v0.21.3/yarn-v0.21.3.tar.gz | tar xz -C /opt && \
  mv /opt/dist /opt/yarn && \
  ln -s /opt/yarn/bin/yarn /usr/local/bin

# Provides cached layer for node_modules
COPY package.json yarn.lock /tmp/
RUN cd /tmp && yarn install
RUN mkdir -p /app \
    && cp -a /tmp/node_modules /app

WORKDIR /app
COPY ./db.json /app/
COPY ./containerEntryPoint.sh /app/
RUN chmod +x /app/containerEntryPoint.sh

EXPOSE 8080

ENV SERVICE_CHECK_HTTP=/health \
    SERVICE_CHECK_INTERVAL=15s \
    SERVICE_CHECK_TIMEOUT=15s \
    APP_NAME=medication-ordering-api \
    SERVICE_NAME=medication-ordering-api

ENTRYPOINT ["./containerEntryPoint.sh"]
CMD [""]
