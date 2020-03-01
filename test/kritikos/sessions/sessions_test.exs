defmodule Kritikos.SessionsTest do
  use Kritikos.DataCase, async: true
  alias Kritikos.Sessions
  alias Kritikos.Votes

  setup do
    {:ok, user} =
      Kritikos.Auth.register_user(%{
        email: "john@doe",
        password: "test",
        password_confirmation: "test",
        first_last_name: "John Doe"
      })

    {:ok, session} =
      Sessions.start(
        Map.merge(%{user_id: user.id}, %{
          name: "Session made in test setup",
          keyword: "setup"
        })
      )

    {:ok, vote} = Votes.submit_vote(session.keyword, 2)

    {:ok, feedback} = Votes.update_or_submit_feedback(vote.id, "Test feedback")

    # simulate session open time
    :timer.sleep(1000)

    [
      user: user,
      session: session,
      vote: vote,
      feedback: feedback
    ]
  end

  describe "sessions lifecycle" do
    @valid_attrs %{
      name: "For testing purposes",
      keyword: "somekeyword",
      start_datetime: "2010-04-17T14:00:00Z"
    }
    @invalid_attrs %{end_datetime: nil, keyword: nil, start_datetime: nil}

    test "starting a session", %{user: u} do
      {:ok, session} = Sessions.start(Map.merge(%{user_id: u.id}, @valid_attrs))

      assert @valid_attrs.keyword == session.keyword
    end

    test "starting an invalid session", %{user: u} do
      {:error, cs} = Sessions.start(Map.merge(%{user_id: u.id}, @invalid_attrs))
      # silence warning
      _ = cs

      assert cs = %Ecto.Changeset{valid?: false}
    end

    test "ending a session", %{session: s} do
      {:ok, updated_session} = Sessions.stop(s.keyword)

      assert s.keyword == updated_session.keyword
      assert s.id == updated_session.id
      assert updated_session.end_datetime != nil
    end
  end

  describe "sessions voting" do
    test "submitting a vote", %{session: s} do
      vote_level = Enum.random(1..3)
      {:ok, vote} = Votes.submit_vote(s.keyword, vote_level)

      assert vote != nil
      assert vote.session_id == s.id
      assert vote.vote_level_id == vote_level
    end

    test "updating an existing vote", %{vote: v} do
      new_vote_level_id = 3
      {:ok, updated_vote} = Votes.update_vote(v.id, %{vote_level_id: new_vote_level_id})

      assert updated_vote.id == v.id
      assert updated_vote.vote_level_id == new_vote_level_id
    end

    test "add feedback", %{vote: v} do
      feedback_text = "THIS IS FEEDBACK!@!!!!!@!@"
      {:ok, feedback} = Votes.update_or_submit_feedback(v.id, feedback_text)

      assert feedback.vote_id == v.id
      assert feedback.text == feedback_text
    end

    test "update existing feedback", %{feedback: fb} do
      updated_feedback_text = "THIS WAS UPDATED!@!!@!@@#$##$#"
      {:ok, updated_feedback} = Votes.update_or_submit_feedback(fb.vote_id, updated_feedback_text)

      assert updated_feedback.vote_id == fb.vote_id
      assert updated_feedback.text != fb.text
      assert updated_feedback.text == updated_feedback_text
    end
  end
end
