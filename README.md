# Kritikos

Web server for the Kritikos app.

## Setup

1. Run postgres container on port 5432

2. Setup DB: `mix ecto.setup`

3. Run `iex -S mix phx.server` to start server supervised by iex, or `mix phx.server` to start server independently
