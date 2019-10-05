defmodule KritikosWeb.PromptController do
  use KritikosWeb, :controller
  alias Kritikos.Sessions.LiveSession

  def live_session(conn, %{"keyword" => keyword}) do
    render_existing_session(conn, "live_session.html", keyword: keyword)
  end

  def kiosk_live_session(conn, %{"keyword" => keyword}) do
    render_existing_session(conn, "kiosk_live_session.html", keyword: keyword)
  end

  def live_session_form(conn, %{"keyword" => keyword}) do
    vote_level = conn.query_params["voteLevel"]

    render_existing_session(conn, "live_session_form.html",
      keyword: keyword,
      vote_level: vote_level
    )
  end

  def submit_form(conn, %{"keyword" => _keyword}) do
    IO.inspect(conn)

    conn |> put_status(:ok) |> text("ok")
  end

  def vote(conn, %{"keyword" => keyword, "level" => level}) do
    {int_level, ""} = Integer.parse(level)

    new_vote = %Kritikos.Votes.Vote{
      session_keyword: keyword,
      vote_level_id: int_level,
      vote_datetime: DateTime.utc_now()
    }

    LiveSession.submit_vote(keyword, new_vote)

    conn |> put_status(:ok) |> text("ok")
  end

  defp render_existing_session(conn, template, params) do
    if LiveSession.exists?(params[:keyword]) do
      render(conn, template, params)
    else
      conn
      |> put_view(KritikosWeb.ErrorView)
      |> render("error.html", reason: "Feedback session #{params[:keyword]} doesn't exist!")
    end
  end
end
