defmodule KritikosWeb.Plug.EnsureAuthenticated do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: "/portal")
        |> halt

      _ ->
        conn
    end
  end
end
