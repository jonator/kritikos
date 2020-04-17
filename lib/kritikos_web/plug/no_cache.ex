defmodule KritikosWeb.Plug.NoCache do
  @behaviour Plug
  alias Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> Conn.put_resp_header("Cache-Control", "no-cache, no-store, must-revalidate")
    |> Conn.put_resp_header("Pragma", "no-cache")
    |> Conn.put_resp_header("Expires", "0")
  end
end
