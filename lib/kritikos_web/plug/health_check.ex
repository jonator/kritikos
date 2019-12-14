defmodule KritikosWeb.Plug.HealthCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/status"} = conn, _opts) do
    conn
    |> send_resp(200, "OK")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
