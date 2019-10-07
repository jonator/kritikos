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
    vote_level = get_session(conn, :vote_level)
    voter_number = get_session(conn, :voter_number)

    if vote_level && voter_number do
      render_existing_session(conn, "live_session_form.html",
        keyword: keyword,
        vote_level: vote_level,
        voter_number: voter_number
      )
    else
      conn |> redirect(to: "/" <> keyword)
    end
  end

  def submit_form(conn, %{"keyword" => keyword}) do
    IO.inspect(conn)

    conn |> put_status(:ok) |> text("ok")
  end

  def vote(conn, %{"keyword" => keyword, "level" => level}) do
    if get_session(conn, :vote_level) && get_session(conn, :voter_number) do
      conn |> redirect(to: "/" <> keyword <> "/form")
    else
      {int_level, ""} = Integer.parse(level)

      new_vote = %Kritikos.Votes.Vote{
        session_keyword: keyword,
        vote_level_id: int_level,
        vote_datetime: DateTime.utc_now()
      }

      voter_number = LiveSession.submit_vote(keyword, new_vote)

      conn
      |> put_session(:vote_level, int_level)
      |> put_session(:voter_number, voter_number)
      |> redirect(to: "/" <> keyword <> "/form")
    end
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
