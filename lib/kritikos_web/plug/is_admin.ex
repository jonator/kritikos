defmodule KritikosWeb.Plug.IsAdmin do
  import Plug.Conn
  alias Kritikos.Auth.User

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{user: %User{email: admin_email}}} = conn, email: admin_email),
    do: assign(conn, :is_admin?, true)

  def call(conn, _),
    do: assign(conn, :is_admin?, false)
end
