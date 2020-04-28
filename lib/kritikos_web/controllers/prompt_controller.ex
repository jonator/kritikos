defmodule KritikosWeb.PromptController do
  use KritikosWeb, :controller
  alias Kritikos.Votes
  alias Kritikos.Sessions
  require Logger

  plug :already_voted?
  plug :session_owner?
  plug KritikosWeb.Plug.AllowIframe

  def live_session(conn, %{"keyword" => keyword}) do
    render_existing_session(conn, "live_session.html", keyword: keyword)
  end

  def kiosk_live_session(conn, %{"keyword" => keyword}) do
    render_existing_session(conn, "live_session.html", keyword: keyword, is_kiosk: true)
  end

  def live_session_form(conn, %{"keyword" => keyword}) do
    %{vote_id: voted_id, vote_level: voted_level} = get_session(conn, :vote)

    voted_level =
      if is_integer(voted_level) do
        voted_level
      else
        Integer.parse(voted_level) |> elem(0)
      end

    if voted_level do
      render_existing_session(conn, "live_session_form.html",
        keyword: keyword,
        vote_level: voted_level,
        vote_id: voted_id
      )
    else
      conn |> redirect(to: "/" <> keyword)
    end
  end

  def submit_feedback(%{assigns: %{session_owner: true}} = conn, %{
        "keyword" => keyword
      }),
      do: render(conn, "redirect.json", redirect: "/" <> keyword <> "/thanks")

  def submit_feedback(conn, %{"vote_id" => vote_id, "text" => text, "keyword" => keyword})
      when is_integer(vote_id) do
    Votes.update_or_submit_feedback(vote_id, text)

    update_host_dashboard_model(vote_id)

    render(conn, "redirect.json", redirect: "/" <> keyword <> "/thanks")
  end

  def submit_feedback(conn, %{"vote_id" => vid_string} = params) do
    {vote_id, ""} = Integer.parse(vid_string)

    submit_feedback(conn, Map.put(params, "vote_id", vote_id))
  end

  def submit_vote(%{assigns: %{session_owner: true}} = conn, %{
        "keyword" => keyword,
        "level" => level
      }),
      do: render_feedback_form(conn, level, nil, keyword)

  def submit_vote(conn, %{"keyword" => keyword, "level" => level}) when is_integer(level) do
    {:ok, vote} =
      case get_session(conn, :vote) do
        %{vote_id: voted_id, keyword: ^keyword} ->
          Votes.update_vote(voted_id, %{vote_level_id: level})

        _ ->
          Votes.submit_vote(keyword, level)
      end

    update_host_dashboard_model(vote.id)

    render_feedback_form(conn, vote.vote_level_id, vote.id, keyword)
  end

  def submit_vote(conn, %{"keyword" => keyword, "level" => level}) do
    {int_vote_level, ""} = Integer.parse(level)

    submit_vote(conn, %{"keyword" => keyword, "level" => int_vote_level})
  end

  def thanks(%Plug.Conn{assigns: %{already_voted: true}} = conn, %{"keyword" => kw}) do
    conn |> render("thanks.html", keyword: kw)
  end

  def thanks(%Plug.Conn{assigns: %{already_voted: false}} = conn, %{"keyword" => kw}) do
    conn |> redirect(to: "/" <> kw)
  end

  defp render_existing_session(conn, template, params) do
    case Sessions.get_open(params[:keyword]) do
      nil ->
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

        params = params ++ [session_owner: conn.assigns[:session_owner]]

        render(conn, template, params ++ [prompt_question: session.prompt_question])
    end
  end

  defp render_feedback_form(conn, vote_level, vote_id, keyword) do
    conn
    |> put_session(:vote, %{vote_level: vote_level, vote_id: vote_id, keyword: keyword})
    |> render("redirect.json", redirect: "/" <> keyword <> "/form")
  end

  defp already_voted?(conn, _plug_params) do
    did_vote = not is_nil(get_session(conn, :vote))
    Plug.Conn.assign(conn, :already_voted, did_vote)
  end

  defp session_owner?(%{params: %{"keyword" => keyword}} = conn, _plug_params) do
    is_owner =
      with %{id: user_id} <- get_session(conn, :user),
           %{user_id: ^user_id} <- Sessions.get_open(keyword) do
        true
      else
        _ ->
          false
      end

    Plug.Conn.assign(conn, :session_owner, is_owner)
  end

  defp update_host_dashboard_model(vote_id) do
    vote = Kritikos.Votes.get_vote(vote_id, preload: [{:session, :user}, :feedback])

    KritikosWeb.DashboardChannel.broadcast_model_update(vote.session.user.id, %{
      vote: Map.drop(vote, [:session])
    })
  end
end