defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions
  alias Kritikos.Auth

  plug KritikosWeb.Plug.EnsureAuthenticated, store: :cookie

  def dashboard(conn, _params, user) do
    token = Auth.sign_user_token(user.id)
    user_record = Auth.get_user_record(user.id)

    user_sessions =
      Sessions.get_for_user_with_preloads(user.id, [:votes, :tags])
      |> Enum.map(&KritikosWeb.FormatHelpers.format_session/1)

    render(conn, "dashboard.html",
      socket_token: token,
      user_record: user_record,
      sessions: user_sessions
    )
  end
end
