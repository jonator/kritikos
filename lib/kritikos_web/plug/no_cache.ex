defmodule Kritikos.Plug.NoCache do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    conn
    |> Plug.Conn.put_resp_header("Cache-Control", "no-cache, no-store, must-revalidate")
    |> Plug.Conn.put_resp_header("Pragma", "no-cache")
    |> Plug.Conn.put_resp_header("Expires", "0")
  end
end
