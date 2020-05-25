defmodule KritikosWeb.PromptControllerTest do
  use KritikosWeb.ConnCase, async: true
  alias Plug.Conn
  alias Kritikos.{Auth, Votes, Sessions}

  @user_create %{
    email: "test@email.com",
    first_last_name: "test mike",
    password: "pass",
    password_confirmation: "pass"
  }

  @session %{
    keyword: "kwtest",
    name: "named_kwtest",
    prompt_question: "custom?"
  }

  setup %{conn: conn} do
    {:ok, owner_user} = Auth.register_user(@user_create)

    {:ok, session} = Map.put(@session, :user_id, owner_user.id) |> Sessions.start()

    conn = Conn.assign(conn, :session_owner, false)

    {:ok, vote} = Votes.submit_vote(session.keyword, Enum.random(1..3))

    %{conn: conn, session: session, vote: vote}
  end

  describe "session workflow web pages:" do
    test "get first session page", %{conn: conn, session: session} do
      conn = get(conn, "/" <> session.keyword)

      assert html_response(conn, 200) =~ "<div id=\"question\">\ncustom?    </div>"
    end

    test "get feedback page form", %{conn: conn, vote: vote, session: %{keyword: keyword}} do
      query_params = vote_query_params(vote)
      conn = get(conn, "/" <> keyword <> "/form" <> query_params)

      assert html_response(conn, 200) =~
               "<h3 class=\"form-details\">Any details of your experience?</h3>"
    end

    test "get thanks view", %{conn: conn, session: %{keyword: keyword}} do
      conn = get(conn, "/" <> keyword <> "/thanks")

      assert html_response(conn, 200) =~ "<h3>Thanks for the feedback!</h3><br/>"
    end
  end

  describe "requests on closed sessions:" do
    setup %{session: %{keyword: keyword}} = global_setup do
      Process.sleep(1000)
      {:ok, closed_session} = Sessions.stop(keyword)

      Map.put(global_setup, :session, closed_session)
    end

    test "get first session page as closed", %{conn: conn, session: %{keyword: keyword}} do
      conn = get(conn, "/" <> keyword)

      assert html_response(conn, 200) =~
               "<h3 id=\"error-reason\">Feedback session &quot;kwtest&quot; was closed or doesn&#39;t exist!</h3>"
    end

    test "get feedback page form right after close", %{
      conn: conn,
      vote: vote,
      session: %{keyword: keyword}
    } do
      query_params = vote_query_params(vote)
      conn = get(conn, "/" <> keyword <> "/form" <> query_params)

      assert html_response(conn, 200) =~
               "<h3 id=\"error-reason\">Feedback session &quot;kwtest&quot; was closed or doesn&#39;t exist!</h3>"
    end

    test "get thanks right after closed", %{conn: conn, session: %{keyword: keyword}} do
      conn = get(conn, "/" <> keyword <> "/thanks")

      # should not be affected by close
      assert html_response(conn, 200) =~ "<h3>Thanks for the feedback!</h3><br/>"
    end
  end

  describe "submitting votes & feedback:" do
    setup %{conn: conn} = global_setup do
      post_api = &post(&1, "/api" <> &2, &3)

      Map.put(global_setup, :post_api, post_api)
      |> Map.put(:conn, put_req_header(conn, "content-type", "application/json"))
    end

    test "submitting vote", %{
      conn: conn,
      session: %{keyword: keyword},
      post_api: post_api
    } do
      vote_level = Integer.to_string(Enum.random(1..3))
      conn = post_api.(conn, "/vote/" <> keyword <> "/" <> vote_level, nil)
      {int_vote_level, ""} = Integer.parse(vote_level)

      assert %{"vote" => %{"voteLevelId" => ^int_vote_level}} = json_response(conn, 200)
    end

    test "submitting feedback", %{
      conn: conn,
      vote: vote,
      session: %{keyword: keyword},
      post_api: post_api
    } do
      body = %{vote_id: vote.id, text: "this is test text"}

      conn = post_api.(conn, "/" <> keyword <> "/submit_form", body)

      assert %{"feedback" => %{"id" => _}} = json_response(conn, 200)
    end
  end

  defp vote_query_params(vote),
    do:
      "?voteLevelId=" <>
        Integer.to_string(vote.vote_level_id) <> "&voteId=" <> Integer.to_string(vote.id)
end
