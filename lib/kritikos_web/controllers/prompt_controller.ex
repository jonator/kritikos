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

  def submit_form(conn, %{"keyword" => keyword} = params) do
    {voter_number, ""} = Integer.parse(params["voter_number"])

    if already_voted?(conn) do
      LiveSession.update_text(keyword, voter_number, params["text"])
    else
      new_text = %Kritikos.Votes.Text{
        session_keyword: keyword,
        text: params["text"],
        voter_number: voter_number
      }

      LiveSession.submit_text(new_text)
    end

    conn |> render("redirect.json", redirect: "/" <> keyword <> "/thanks")
  end

  def vote(conn, %{"keyword" => keyword, "level" => level}) do
    conn =
      if already_voted?(conn) do
        voter_number = get_session(conn, :voter_number)
        LiveSession.update_vote(keyword, voter_number, level)
        conn
      else
        {int_level, ""} = Integer.parse(level)

        new_vote = %Kritikos.Votes.Vote{
          session_keyword: keyword,
          vote_level_id: int_level,
          vote_datetime: DateTime.utc_now()
        }

        voter_number = LiveSession.submit_vote(new_vote)

        conn
        |> put_session(:vote_level, int_level)
        |> put_session(:voter_number, voter_number)
      end

    conn |> render("redirect.json", redirect: "/" <> keyword <> "/form")
  end

  def thanks(conn, %{"keyword" => keyword}) do
    if !already_voted?(conn) do
      conn |> redirect(to: "/" <> keyword)
    else
      conn |> render("thanks.html")
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

  defp already_voted?(conn) do
    get_session(conn, :vote_level) && get_session(conn, :voter_number)
  end
end
