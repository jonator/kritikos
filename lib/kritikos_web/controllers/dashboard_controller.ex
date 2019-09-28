defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"

  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def dashboard(conn, _params, _user) do
    render(conn, "dashboard.html")
  end

  def new_session(conn, _params, _user) do
    render(conn, "new_session.html")
  end

  def current_session(conn, params, user) do
    user_sessions =
      Registry.select(:sessions_registry, [
        {{:"$1", :"$2", :"$3"}, [{:==, :"$3", user.id}], [{{:"$2"}}]}
      ])

    IO.inspect(user_sessions)

    if params["spawn"] == "true" && Enum.count(user_sessions) == 0 do
      {:ok, pid} = Sessions.start(user.id)
      live_session = :sys.get_state(pid)
      render(conn, "current_session.html", live_session: live_session)
    else
      case user_sessions do
        [{pid}] ->
          live_session = :sys.get_state(pid)
          render(conn, "current_session.html", live_session: live_session)

        _ ->
          redirect(conn, to: "/dashboard")
      end
    end
  end

  def previous_sessions(conn, _params, _user) do
    render(conn, "previous_sessions.html")
  end

  def all_sessions(conn, _params, _user) do
    render(conn, "all_sessions.html")
  end
end
