defmodule KritikosWeb.Plug.EnsureAuthenticated do
  @behaviour Plug
  import Plug.Conn
  alias Kritikos.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        redirect_to_portal(conn)

      user ->
        case Auth.get_user(user.id) do
          nil ->
            redirect_to_portal(conn)

          %Auth.User{is_active: false} ->
            redirect_to_portal(conn)

          _ ->
            conn
        end
    end
  end

  defp redirect_to_portal(conn) do
    conn
    |> Phoenix.Controller.redirect(to: "/portal")
    |> halt
  end
end
