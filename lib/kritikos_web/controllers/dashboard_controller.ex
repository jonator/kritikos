defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.Auth

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :cookie

  def dashboard(conn, _params, user) do
    token = Auth.sign_user_token(user.id)
    user_record = Auth.get_user(user.id, preload: :profile)
    user_sessions = Sessions.get_for_user(user.id, preload: [{:votes, :feedback}, :tags])

    render(conn, "dashboard.html",
      socket_token: token,
      user_record: user_record,
      sessions: user_sessions
    )
  end
end
