defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.Auth

  plug KritikosWeb.Plug.EnsureAuthenticated

  def dashboard(conn, _params, user) do
    user_record = Auth.get_user_record(user.id)
    user_sessions = Sessions.get_user_sessions(user.id)

    IO.inspect([user_record, user_sessions])

    render(conn, "dashboard.html", user_record: user_record, sessions: user_sessions)
  end
end
