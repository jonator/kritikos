defmodule Kritikos.Application do
  use Application

  def start(_type, _args) do
    children = [
      Kritikos.Repo,
      KritikosWeb.Endpoint,
      {Registry, [{:keys, :unique}, {:name, :sessions_registry}]}
    ]

    opts = [strategy: :one_for_one, name: Kritikos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    KritikosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
