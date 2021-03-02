defmodule KritikosWeb.Plug.NoCache do
  @moduledoc """
  Plug disables browser cache on user connection.
  """
  @behaviour Plug
  alias Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> Conn.put_resp_header("cache-control", "no-cache, no-store, must-revalidate")
    |> Conn.put_resp_header("pragma", "no-cache")
    |> Conn.put_resp_header("expires", "0")
  end
end
