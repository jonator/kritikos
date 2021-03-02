defmodule Kritikos.Application do
  @moduledoc """
  Defines root Kritikos processes.
  """
  use Application

  def start(_type, _args) do
    children = [
      Kritikos.Repo,
      {Phoenix.PubSub, name: Kritikos.PubSub},
      KritikosWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Kritikos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    KritikosWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def fetch_host do
    Application.fetch_env!(:kritikos, KritikosWeb.Endpoint)[:url][:scheme] <>
      Application.fetch_env!(:kritikos, KritikosWeb.Endpoint)[:url][:host]
  end
end
