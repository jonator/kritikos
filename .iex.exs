import Ecto.Query
alias Kritikos.Repo
alias Kritikos.Auth
alias Kritikos.Auth.{User, Profile}
alias Kritikos.Sessions
alias Kritikos.Sessions.{Session, Tag}
alias Kritikos.Votes
alias Kritikos.Votes.{Vote, Feedback}

Module.create(
  H,
  quote do
    require Ecto.Query

    def delete_all_models do
      delete_all_inorder([Feedback, Vote, Tag, Session])
    end

    def delete_all_inorder(list) do
      Enum.map(list, fn schema ->
        Repo.delete_all(schema)
      end)
    end

    def create_scenario_for_user_id(user_id) do
      delete_all_models()
      user = Auth.get_active_user(user_id) |> elem(1) |> Repo.preload(:profile)
      user_session = %Session{profile_id: user.profile.id}

      keywords = ["apples", "bannanas", "fruit", "test", "abc", "wowow", "test2", "work"]

      session_inserts =
        Enum.map(keywords, fn k ->
          attrs = %{
            tags: Enum.shuffle(keywords) |> Enum.map(fn t -> %{text: t} end),
            prompt_question: "This is " <> k <> "?",
            keyword: k,
            name: "Named " <> k
          }

          Session.create_changeset(user_session, attrs) |> Repo.insert() |> elem(1)
        end)

      vote_inserts =
        Enum.map(session_inserts, fn s ->
          Enum.map(keywords, fn k ->
            vote = Ecto.build_assoc(s, :votes, vote_level_id: Enum.random(1..3))
            Vote.create_changeset(vote, %{}) |> Repo.insert() |> elem(1)
          end)
        end)
        |> List.flatten()

      feedback_inserts =
        Enum.map(vote_inserts, fn v ->
          feedback = Ecto.build_assoc(v, :feedback, text: Enum.random(keywords))
          Feedback.changeset(feedback, %{}) |> Repo.insert() |> elem(1)
        end)

      %{sessions: session_inserts, votes: vote_inserts, feedback: feedback_inserts}
    end

    def vote_random(profile_id) when is_integer(profile_id) do
      {:ok, vote} =
        Repo.all(from(s in Session, where: s.profile_id == ^profile_id, select: s.keyword))
        |> Enum.random()
        |> Votes.submit_vote(Enum.random(1..3))

      KritikosWeb.DashboardChannel.broadcast_model_update(profile_id, %{vote: vote})
    end

    def vote_random(profile_id, session_keyword) do
      {:ok, vote} = Votes.submit_vote(session_keyword, Enum.random(1..3))

      KritikosWeb.DashboardChannel.broadcast_model_update(profile_id, %{vote: vote})
    end

    def gen_vote_random(profile_id, n) do
      Enum.map(1..n, fn _ -> vote_random(profile_id) end)
    end
  end,
  Macro.Env.location(__ENV__)
)

IO.puts("iex config loaded")
