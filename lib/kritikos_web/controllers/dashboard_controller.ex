defmodule KritikosWeb.DashboardController do
  use KritikosWeb, :controller
  use KritikosWeb.GuardedController
  alias Kritikos.Sessions

  plug KritikosWeb.Plug.EnsureAuthenticated
  plug :put_layout, "header.html"
  plug KritikosWeb.Plug.PutAssigns, button: %{id: "log-out", href: "/", text: "Log out"}

  def dashboard(conn, _params, user) do
    keyword =
      case Sessions.LiveSession.take_state(user.id, [:keyword]) do
        %{keyword: keyword} ->
          keyword

        :not_found ->
          nil
      end

    render(conn, "dashboard.html", keyword: keyword)
  end

  def new_session(conn, _params, user) do
    case Sessions.LiveSession.take_state(user.id, [:keyword]) do
      %{keyword: _} ->
        redirect(conn, to: "/dashboard/currentSession")

      :not_found ->
        render(conn, "new_session.html")
    end
  end

  def current_session(conn, params, user) do
    case Sessions.LiveSession.take_state(user.id, [:keyword, :votes]) do
      %{keyword: _, votes: _} = live_session_state ->
        render(conn, "current_session.html", live_session: live_session_state)

      :not_found ->
        if params["spawn"] == "true" do
          start_new_session(conn, user.id)
        else
          conn |> redirect(to: "/dashboard")
        end
    end
  end

  def close_current_session(conn, _params, user) do
    case Sessions.LiveSession.take_state(user.id, [:keyword]) do
      %{keyword: keyword} ->
        :ok = Kritikos.Sessions.LiveSession.conclude(keyword)

      :not_found ->
        nil
    end

    conn |> json(%{redirect: "/dashboard"})
  end

  def previous_sessions(conn, _params, user) do
    summaries = Sessions.summaries_for_user(user.id)
    render(conn, "previous_sessions.html", summaries: summaries)
  end

  def previous_session(conn, %{"keyword" => keyword}, user) do
    case Sessions.previous_overview(keyword, user.id) do
      {:ok, session, votes, texts} ->
        levels = Kritikos.Votes.vote_levels_descriptions()

        render(conn, "previous_session.html",
          session: session,
          votes: votes,
          texts: texts,
          levels: levels
        )

      {:error, msg} ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.html", reason: msg)
    end
  end

  def all_sessions(conn, _params, user) do
    overview = Sessions.all_overview(user.id)
    levels = Kritikos.Votes.vote_levels_descriptions()
    render(conn, "all_sessions.html", overview: overview, levels: levels)
  end

  def start_new_session(conn, user_id) do
    {:ok, pid} = Sessions.start(user_id)

    case Sessions.LiveSession.take_state(pid, [:keyword, :votes]) do
      %{keyword: _, votes: _} = live_session_state ->
        render(conn, "current_session.html", live_session: live_session_state)

      _ ->
        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.html", reason: "Problem starting session")
    end
  end
end
