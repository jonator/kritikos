defmodule KritikosWeb.Plug.EnsureAuthenticated do
  @behaviour Plug
  import Plug.Conn
  import Ecto.Query, only: [from: 2]
  alias Kritikos.Auth.User

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        redirect_to_portal(conn)

      user ->
        query = from u in User, where: u.id == ^user.id

        case Kritikos.Repo.one(query) do
          nil ->
            redirect_to_portal(conn)

          %User{is_active: false} ->
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
