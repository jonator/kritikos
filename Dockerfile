# building: docker build --force-rm -t kritikos:latest .

ARG ALPINE_VERSION=3.9

FROM elixir:alpine as builder

ARG APP_NAME=kritikos
# must match mix.env project version
ARG APP_VSN=0.1.0
ARG MIX_ENV=prod

ENV \
    APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    nodejs \
    npm \
    git \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# excludes what is in .dockerignore
COPY . .

RUN \
    mix deps.get --only prod && \
    cd ./assets && \
    npm install && \
    npm run deploy && \
    cd .. && \
    mix phx.digest

RUN \
    mkdir -p /opt/built && \
    mix release --version ${APP_VSN} && \
    cp -r _build/${MIX_ENV}/rel/ /opt/built

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME=kritikos
ARG SECRET

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME} \
    SECRET=${SECRET}

COPY --from=builder /opt/built .

COPY ./priv/deploy.sh .

CMD [ "./deploy.sh"]
