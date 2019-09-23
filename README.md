# Kritikos

Web server for the Kritikos app.

## Setup

1. Run postgres container on port 5432

2. Setup DB: `mix ecto.setup`

3. Setup client: `cd assets && npm install`

3. Run `iex -S mix phx.server` to start server supervised by iex, or `mix phx.server` to start server independently

## Deploy

1. Determine app version (`<vsn>`)
2. Build web server: `docker build --force-rm -t kritikos:<vsn> .`
3. Database: `docker run --name kritikos_pgprod -p 5432:5432 postgres:alpine`

4. Web server: `docker run -it --env-file ./config/prod.env --name kritikos -p 4000:4000 kritikos:<vsn>`
