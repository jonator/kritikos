defmodule KritikosWeb.PromptController do
  use KritikosWeb, :controller
  alias Kritikos.Sessions.LiveSession
  require Logger

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

    new_text = %Kritikos.Votes.Text{
      text: params["text"],
      voter_number: voter_number
    }

    LiveSession.submit_text(keyword, new_text)

    conn |> render("redirect.json", redirect: "/" <> keyword <> "/thanks")
  end

  def vote(conn, %{"keyword" => keyword, "level" => level}) do
    {int_level, ""} = Integer.parse(level)
    voter_number_nullable = get_session(conn, :voter_number)

    new_vote = %Kritikos.Votes.Vote{
      vote_level_id: int_level,
      vote_datetime: DateTime.utc_now(),
      voter_number: voter_number_nullable
    }

    voter_number = LiveSession.submit_vote(keyword, new_vote)

    conn
    |> put_session(:vote_level, int_level)
    |> put_session(:voter_number, voter_number)
    |> render("redirect.json", redirect: "/" <> keyword <> "/form")
  end

  def thanks(conn, %{"keyword" => keyword}) do
    if already_voted?(conn) do
      conn |> render_existing_session("thanks.html", keyword: keyword)
    else
      conn |> redirect(to: "/" <> keyword)
    end
  end

  defp render_existing_session(conn, template, params) do
    if LiveSession.exists?(params[:keyword]) do
      render(conn, template, params)
    else
      warn_unrecognized_request(conn)

      conn
      |> put_view(KritikosWeb.ErrorView)
      |> render("error.html", reason: "Feedback session #{params[:keyword]} doesn't exist!")
    end
  end

  defp already_voted?(conn) do
    get_session(conn, :vote_level) && get_session(conn, :voter_number)
  end

  defp warn_unrecognized_request(conn) do
    [a, b, c, d | _] = conn.remote_ip |> Tuple.to_list()

    Logger.warn(
      "Remote ip: " <>
        Integer.to_string(a) <>
        "." <>
        Integer.to_string(b) <>
        "." <>
        Integer.to_string(c) <>
        "." <>
        Integer.to_string(d)
    )
  end
end
