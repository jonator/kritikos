# Kritikos

Web server for the Kritikos app.

## Dev Setup

1. Run postgres container on port 5432

    `docker run -it --name kritikos_pg_dev -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:alpine`

2. Clone repo, Setup DB & run migrations

    `mix ecto.setup`

3. Setup client assets (js, svg, css, etc.)

    `cd assets && npm install`

3. Install elixir (on mac)

    `brew install elixir`
    
4. Start server

    `iex -S mix phx.server` to start server under interactive elixir, or `mix phx.server` to start server independently


## Deployment

1. Get the following secrets, put into `./rel/`

    i. Google Auth Cloud SQL Service Account JSON artifact

2. Update version in mix.exs and run

    `make build`

3. Push to registry (replace version)

    `make push`

4. SSH into root@kritikos.app droplet, update `docker-compose.yaml` to reflect newer web image version on registry, run `docker-compose up -d`
