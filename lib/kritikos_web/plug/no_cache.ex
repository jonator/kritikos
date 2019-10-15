defmodule Kritikos.Plug.NoCache do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    Plug.Conn.put_resp_header(conn, "Cache-Controler", "no-store")
  end
end
