# building: docker build --force-rm -t kritikos:latest .

ARG ALPINE_VERSION=3.9

FROM elixir:alpine as builder

ARG APP_NAME=kritikos
ARG APP_VSN=0.0.1
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

COPY . .

RUN \
    cd ./assets && \
    npm install && \
    npm run deploy && \
    cd .. && \
    mix phx.digest

RUN \
    mkdir -p /opt/built && \
    mix release prod && \
    cp _build/${MIX_ENV}/rel/${APP_NAME}/bin/${APP_NAME} /opt/built

FROM alpine:${ALPINE_VERSION}

ARG APP_NAME=kritikos

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl-dev

ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME}

WORKDIR /opt/app

COPY --from=builder /opt/built .