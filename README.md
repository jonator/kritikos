# Kritikos

Web server for the Kritikos app.

## Setup

1. Run postgres container on port 5432

2. Setup DB: `mix ecto.setup`

3. Setup client: `cd assets && npm install`

3. Run `iex -S mix phx.server` to start server supervised by iex, or `mix phx.server` to start server independently

## Deploy

1. Determine image tag (`<TAG>`)
2. Build web server on Google Cloud: `gcloud builds submit --substitutions _TAG=<TAG>,_SECRET=`mix phx.gen.secret` .`
3. Update container's tag in `kritikos-web-deployment.yaml` then `kubectl apply`
