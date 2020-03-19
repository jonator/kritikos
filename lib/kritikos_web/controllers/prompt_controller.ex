defmodule KritikosWeb.PromptController do
  use KritikosWeb, :controller
  alias Kritikos.Votes
  alias Kritikos.Sessions
  require Logger

  plug :already_voted?
  plug Kritikos.Plug.AllowIframe

  def live_session(conn, %{"keyword" => keyword}) do
    render_existing_session(conn, "live_session.html", keyword: keyword)
  end

  def kiosk_live_session(conn, %{"keyword" => keyword}) do
    render_existing_session(conn, "live_session.html", keyword: keyword, is_kiosk: true)
  end

  def live_session_form(conn, %{"keyword" => keyword}) do
    %{vote_id: voted_id, vote_level: voted_level} = get_session(conn, :vote)

    if voted_level && voted_id do
      render_existing_session(conn, "live_session_form.html",
        keyword: keyword,
        vote_level: voted_level,
        vote_id: voted_id
      )
    else
      conn |> redirect(to: "/" <> keyword)
    end
  end

  def submit_feedback(conn, %{"keyword" => keyword} = params) do
    {vote_id, ""} = Integer.parse(params["vote_id"])

    Votes.update_or_submit_feedback(vote_id, params["text"])

    update_host_dashboard_model(vote_id)

    conn |> render("redirect.json", redirect: "/" <> keyword <> "/thanks")
  end

  def submit_vote(conn, %{"keyword" => keyword, "level" => level}) do
    {int_vote_level, ""} = Integer.parse(level)

    {:ok, vote} =
      case get_session(conn, :vote) do
        %{vote_id: voted_id, keyword: ^keyword} ->
          Votes.update_vote(voted_id, %{vote_level_id: int_vote_level})

        _ ->
          Votes.submit_vote(keyword, int_vote_level)
      end

    update_host_dashboard_model(vote.id)

    render_feedback_form(conn, vote.vote_level_id, vote.id, keyword)
  end

  def thanks(conn, %{"keyword" => keyword}) do
    if conn.assigns[:already_voted] do
      conn |> render_existing_session("thanks.html", keyword: keyword)
    else
      conn |> redirect(to: "/" <> keyword)
    end
  end

  defp render_existing_session(conn, template, params) do
    case Sessions.get_open(params[:keyword]) do
      nil ->
        warn_unrecognized_request(conn)

        conn
        |> put_view(KritikosWeb.ErrorView)
        |> render("error.html",
          message: "Feedback session \"#{params[:keyword]}\" was closed or doesn't exist!"
        )

      session ->
        params =
          if params[:is_kiosk] == nil do
            params ++ [is_kiosk: nil]
          else
            params
          end

        render(conn, template, params ++ [prompt_question: session.prompt_question])
    end
  end

  defp render_feedback_form(conn, vote_level, vote_id, keyword) do
    conn
    |> put_session(:vote, %{vote_level: vote_level, vote_id: vote_id, keyword: keyword})
    |> render("redirect.json", redirect: "/" <> keyword <> "/form")
  end

  defp already_voted?(conn, _params) do
    did_vote = get_session(conn, :vote) != nil
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

  defp update_host_dashboard_model(vote_id) do
    vote = Kritikos.Votes.get_vote(vote_id, preload: [{:session, :user}, :feedback])

    KritikosWeb.DashboardChannel.broadcast_model_update(vote.session.user.id, %{
      vote: Map.drop(vote, [:session])
    })
  end
end
