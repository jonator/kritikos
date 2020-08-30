FROM elixir:alpine
ARG app_name=kritikos
ENV MIX_ENV=prod TERM=xterm PORT=8080
WORKDIR /opt/app
RUN apk update \
    && apk --no-cache --update add nodejs nodejs-npm build-base git \
    && mix local.rebar --force \
    && mix local.hex --force
COPY . .
RUN mix deps.get --only prod
RUN cd assets \
    && npm install \
    && npm run deploy \
    && cd .. \
    && mix phx.digest
RUN mix release ${app_name} \
    && mv _build/prod/rel/${app_name} /opt/release \
    && mv /opt/release/bin/${app_name} /opt/release/bin/start_server

FROM alpine:3.9
ARG secret
ARG db_pass
ARG mailgun_api_key
ARG stripe_api_key
RUN apk update \
    && apk --no-cache --update add bash ca-certificates openssl-dev wkhtmltopdf ttf-opensans
ENV PORT=8080 REPLACE_OS_VARS=true SECRET=${secret} POSTGRES_PASSWORD=${db_pass} MAILGUN_API_KEY=${mailgun_api_key} STRIPE_API_KEY=${stripe_api_key}
EXPOSE ${PORT}
WORKDIR /opt/app
COPY --from=0 /opt/release .
CMD ./bin/start_server eval "Kritikos.ReleaseTasks.migrate_database" && \
    ./bin/start_server start