defmodule KritikosWeb.PromptControllerTest do
  use KritikosWeb.ConnCase, async: true
  alias Plug.Conn
  alias Plug.Test
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
      vote_session = %{vote_level: vote.vote_level_id, vote_id: vote.id, keyword: keyword}

      conn =
        conn
        |> Test.init_test_session(%{vote: vote_session})
        |> get("/" <> keyword <> "/form")

      assert html_response(conn, 200) =~
               "<h3 class=\"form-details\">Any details of your experience?</h3>"
    end

    test "get thanks view", %{conn: conn, session: %{keyword: keyword}} do
      conn =
        conn
        |> Test.init_test_session(%{vote: "this is the vote we gave, would be struct"})
        |> get("/" <> keyword <> "/thanks")

      assert html_response(conn, 200) =~ "<h1>Thanks for the feedback!</h1><br/>"
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
      vote_session = %{vote_level: vote.vote_level_id, vote_id: vote.id, keyword: keyword}

      conn =
        conn
        |> Test.init_test_session(%{
          vote: vote_session
        })
        |> get("/" <> keyword <> "/form")

      assert html_response(conn, 200) =~
               "<h3 id=\"error-reason\">Feedback session &quot;kwtest&quot; was closed or doesn&#39;t exist!</h3>"
    end

    test "get thanks right after closed", %{conn: conn, session: %{keyword: keyword}} do
      conn =
        conn
        |> Test.init_test_session(%{vote: "this is the vote we gave, would be struct"})
        |> get("/" <> keyword <> "/thanks")

      # should not be affected by close
      assert html_response(conn, 200) =~ "<h1>Thanks for the feedback!</h1><br/>"
    end
  end

  describe "submitting votes:" do
    setup %{conn: conn} = global_setup do
      post_api = &post(&1, "/api" <> &2, &3)

      Map.put(global_setup, :post_api, post_api)
      |> Map.put(:conn, put_req_header(conn, "content-type", "application/json"))
    end

    test "submitting vote, redirect feedback form", %{
      conn: conn,
      session: %{keyword: keyword},
      post_api: post_api
    } do
      vote_level = Integer.to_string(Enum.random(1..3))
      conn = post_api.(conn, "/vote/" <> keyword <> "/" <> vote_level, nil)

      assert json_response(conn, 200) == %{"redirect" => "/kwtest/form"}
    end

    test "submitting feedback, redirect thanks", %{
      conn: conn,
      vote: vote,
      session: %{keyword: keyword},
      post_api: post_api
    } do
      body = %{vote_id: vote.id, text: "this is test text"}

      conn =
        conn
        |> Test.init_test_session(%{vote: vote})
        |> post_api.("/" <> keyword <> "/submit_form", body)

      assert json_response(conn, 200) == %{"redirect" => "/kwtest/thanks"}
    end
  end
end
