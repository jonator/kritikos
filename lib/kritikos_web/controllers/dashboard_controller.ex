defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.Auth

  @token_salt Application.get_env(:kritikos, KritikosWeb.Endpoint)[:secret_key_base]

  plug KritikosWeb.Plug.EnsureAuthenticated

  def dashboard(conn, _params, user) do
    token = Phoenix.Token.sign(KritikosWeb.Endpoint, @token_salt, user.id)
    user_record = Auth.get_user_record(user.id)
    user_sessions = Sessions.get_for_user(user.id)

    render(conn, "dashboard.html",
      socket_token: token,
      user_record: user_record,
      sessions: user_sessions
    )
  end
end
