defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.Auth

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :cookie
  plug KritikosWeb.Plug.IsAdmin, email: "jonathanator0@gmail.com"

  def dashboard(conn, _params, user) do
    token = Auth.sign_user_token(user.id)

    user =
      Auth.get_user(user.id) |> Map.from_struct() |> Map.put(:is_admin, conn.assigns.is_admin?)

    user_sessions = Sessions.get_for_user(user.id, preload: [{:votes, :feedback}, :tags])

    render(conn, "dashboard.html",
      socket_token: token,
      user_record: user,
      sessions: user_sessions
    )
  end
end
