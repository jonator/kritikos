FROM elixir:alpine
ARG app_name=kritikos
ARG build_env=prod
ENV MIX_ENV=${build_env} TERM=xterm
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
    && mv _build/${build_env}/rel/${app_name} /opt/release \
    && mv /opt/release/bin/${app_name} /opt/release/bin/start_server

FROM alpine:3.9
ARG project_id
ARG secret
RUN apk update \
    && apk --no-cache --update add bash ca-certificates openssl-dev \
    && mkdir -p /usr/local/bin \
    && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
        -O /usr/local/bin/cloud_sql_proxy \
    && chmod +x /usr/local/bin/cloud_sql_proxy \
    && mkdir -p /tmp/cloudsql
ENV PORT=8080 GCLOUD_PROJECT_ID=${project_id} REPLACE_OS_VARS=true SECRET=${secret}
EXPOSE ${PORT}
WORKDIR /opt/app
COPY --from=0 /opt/release .
CMD (/usr/local/bin/cloud_sql_proxy \
      -projects=${GCLOUD_PROJECT_ID} -dir=/tmp/cloudsql &) && \
    ./bin/start_server eval "Kritikos.ReleaseTasks.migrate_database" && \
    ./bin/start_server start