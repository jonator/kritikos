defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"

  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def dashboard(conn, _params, user) do
    current_session =
      case get_user_sessions(user.id) do
        {:ok, livesession_pid} ->
          :sys.get_state(livesession_pid)

        :not_found ->
          nil
      end

    render(conn, "dashboard.html", current_session: current_session)
  end

  def new_session(conn, _params, user) do
    case get_user_sessions(user.id) do
      {:ok, _} ->
        redirect(conn, to: "/dashboard/currentSession")

      :not_found ->
        render(conn, "new_session.html")
    end
  end

  def current_session(conn, params, user) do
    case get_user_sessions(user.id) do
      {:ok, pid} ->
        render_session(conn, pid)

      :not_found ->
        if params["spawn"] == "true" do
          {:ok, pid} = Sessions.start(user.id)
          render_session(conn, pid)
        else
          conn |> redirect(to: "/dashboard")
        end
    end
  end

  def close_current_session(conn, _params, user) do
    case get_user_sessions(user.id) do
      {:ok, session_pid} ->
        Process.exit(session_pid, :kill)
    end

    conn |> json(%{redirect: "/dashboard"})
  end

  def previous_sessions(conn, _params, _user) do
    render(conn, "previous_sessions.html")
  end

  def all_sessions(conn, _params, _user) do
    render(conn, "all_sessions.html")
  end

  defp get_user_sessions(user_id) do
    case Registry.select(Kritikos.SessionsRegistry, [
           {{:"$1", :"$2", :"$3"}, [{:==, :"$3", user_id}], [:"$2"]}
         ]) do
      [pid] when is_pid(pid) ->
        {:ok, pid}

      _ ->
        :not_found
    end
  end

  defp render_session(conn, pid) do
    live_session = :sys.get_state(pid)
    render(conn, "current_session.html", live_session: live_session)
  end
end
