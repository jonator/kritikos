# docker build --rm -t kritikos-web:latest -t kritikos-web:mvp1 --build-arg secret=`mix phx.gen.secret`,project_id=kritikos-257816 .
# does not include migrating database
FROM elixir:alpine
ARG app_name=kritikos
ENV MIX_ENV=prod TERM=xterm
WORKDIR /opt/app
RUN apk update \
    && apk --no-cache --update add nodejs nodejs-npm build-base \
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
RUN apk update \
    && apk --no-cache --update add bash ca-certificates openssl-dev \
    && mkdir -p /usr/local/bin \
    && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
    -O /usr/local/bin/cloud_sql_proxy \
    && chmod +x /usr/local/bin/cloud_sql_proxy \
    && mkdir -p /tmp/cloudsql
ENV PORT=8080 REPLACE_OS_VARS=true SECRET=${secret}
EXPOSE ${PORT}
WORKDIR /opt/app
COPY rel/kritikos-257816-0a56ad203b89.json .
ENV GOOGLE_APPLICATION_CREDENTIALS=/opt/app/kritikos-257816-0a56ad203b89.json
COPY --from=0 /opt/release .
CMD (cloud_sql_proxy -instances=kritikos-257816:us-central1:kritikos-db -dir=/tmp/cloudsql &) && \
    ./bin/start_server eval "Kritikos.ReleaseTasks.migrate_database" && \
    ./bin/start_server start