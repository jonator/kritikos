# Kritikos

A simple web app for collecting feedback from anyone via short prompts.

## Development

1. Run postgres container on port 5432

    `docker run -it --name kritikos_pg_dev -p 5432:5432 -e POSTGRES_PASSWORD=postgres postgres:alpine`

2. Clone repo, Setup DB & run migrations

    `mix ecto.setup`

3. Setup client assets (js, svg, css, etc.)

    `cd assets && npm i && cd -`

3. Install elixir (on mac)

    `brew install elixir`
    
4. Start server

    `iex -S mix phx.server` to start server under interactive elixir, or `mix phx.server` to start server independently


## Deployment

1. Update version in `mix.exs`

2. Run `make deploy`