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
      {start_session_status, session} = Sessions.start(Map.merge(%{user_id: u.id}, @valid_attrs))

      assert start_session_status == :ok
      assert @valid_attrs.keyword == session.keyword
    end

    test "starting an invalid session", %{user: u} do
      {session_start_status, cs} = Sessions.start(Map.merge(%{user_id: u.id}, @invalid_attrs))
      # silence warning
      _ = cs

      assert session_start_status == :error
      assert cs = %Ecto.Changeset{valid?: false}
    end

    test "deleting session", %{session: s} do
      {:ok, deleted_session} = Sessions.delete(s.id)

      assert deleted_session.is_active == false
    end

    test "ending a session", %{session: s} do
      {end_session_status, updated_session} = Sessions.stop(s.keyword)

      assert end_session_status == :ok
      assert s.keyword == updated_session.keyword
      assert s.id == updated_session.id
      assert updated_session.end_datetime != nil
    end
  end

  describe "sessions voting" do
    test "submitting a vote", %{session: s} do
      vote_level = Enum.random(1..3)
      {vote_status, vote} = Votes.submit_vote(s.keyword, vote_level)

      assert vote != nil
      assert vote_status == :ok
      assert vote.session_id == s.id
      assert vote.vote_level_id == vote_level
    end

    test "voting on a closed session", %{session: %{keyword: k}} do
      {:ok, closed_session} = Sessions.stop(k)
      {try_vote_status, _} = Votes.submit_vote(k, Enum.random(1..3))

      assert closed_session.end_datetime != nil
      assert try_vote_status == :error
    end

    test "updating vote on closed session", %{session: %{keyword: k}, vote: v} do
      {:ok, closed_session} = Sessions.stop(k)
      {try_update_vote_status, _} = Votes.update_vote(v.id, %{vote_level_id: Enum.random(1..3)})

      assert closed_session.end_datetime != nil
      assert try_update_vote_status == :error
    end

    test "updating an existing vote", %{vote: v} do
      new_vote_level_id = 3

      {update_vote_status, updated_vote} =
        Votes.update_vote(v.id, %{vote_level_id: new_vote_level_id})

      assert update_vote_status == :ok
      assert updated_vote.id == v.id
      assert updated_vote.vote_level_id == new_vote_level_id
    end

    test "add feedback", %{vote: v} do
      feedback_text = "THIS IS FEEDBACK!@!!!!!@!@"
      {add_feedback_status, feedback} = Votes.update_or_submit_feedback(v.id, feedback_text)

      assert add_feedback_status == :ok
      assert feedback.vote_id == v.id
      assert feedback.text == feedback_text
    end

    test "sending feedback on a closed session", %{session: %{keyword: k}, vote: v} do
      {:ok, closed_session} = Sessions.stop(k)
      feedback_text = "should fail"
      {try_feedback_status, _} = Votes.update_or_submit_feedback(v.id, feedback_text)

      assert closed_session.end_datetime != nil
      assert try_feedback_status == :error
    end

    test "update existing feedback", %{feedback: fb} do
      updated_feedback_text = "THIS WAS UPDATED!@!!@!@@#$##$#"

      {update_feedback_status, updated_feedback} =
        Votes.update_or_submit_feedback(fb.vote_id, updated_feedback_text)

      assert update_feedback_status == :ok
      assert updated_feedback.vote_id == fb.vote_id
      assert updated_feedback.text != fb.text
      assert updated_feedback.text == updated_feedback_text
    end
  end
end
