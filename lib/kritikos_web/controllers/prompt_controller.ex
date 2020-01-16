defmodule KritikosWeb.PromptController do
  use KritikosWeb, :controller
  alias Kritikos.Votes
  alias Kritikos.Sessions
  require Logger

  plug :already_voted?

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

  def submit_feedback(conn, %{"keyword" => keyword} = params) do
    {voter_number, ""} = Integer.parse(params["voter_number"])

    Votes.update_or_submit_feedback(voter_number, params["text"])

    conn |> render("redirect.json", redirect: "/" <> keyword <> "/thanks")
  end

  def submit_vote(conn, %{"keyword" => keyword, "level" => level}) do
    {int_vote_level, ""} = Integer.parse(level)
    voter_number_nullable = get_session(conn, :voter_number)

    vote =
      if voter_number_nullable == nil do
        Votes.submit_vote(keyword, int_vote_level)
      else
        Votes.update_vote(voter_number_nullable, %{vote_level_id: int_vote_level})
      end

    render_feedback_form(conn, vote.vote_level_id, vote.voter_number, keyword)
  end

  def thanks(conn, %{"keyword" => keyword}) do
    if conn.assigns[:already_voted] do
      conn |> render_existing_session("thanks.html", keyword: keyword)
    else
      conn |> redirect(to: "/" <> keyword)
    end
  end

  defp render_existing_session(conn, template, params) do
    if Sessions.get_open(params[:keyword]) != nil do
      render(conn, template, params)
    else
      warn_unrecognized_request(conn)

      conn
      |> put_view(KritikosWeb.ErrorView)
      |> render("error.html", message: "Feedback session #{params[:keyword]} doesn't exist!")
    end
  end

  defp render_feedback_form(conn, vote_level, voter_number, keyword) do
    conn
    |> put_session(:vote_level, vote_level)
    |> put_session(:voter_number, voter_number)
    |> render("redirect.json", redirect: "/" <> keyword <> "/form")
  end

  defp already_voted?(conn, _params) do
    did_vote = get_session(conn, :vote_level) && get_session(conn, :voter_number)

    Plug.Conn.assign(conn, :already_voted, did_vote)
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
