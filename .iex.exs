import Ecto.Query
alias Kritikos.Repo
alias Kritikos.Auth
alias Kritikos.Auth.User
alias Kritikos.Sessions
alias Kritikos.Sessions.{Session, Tag}
alias Kritikos.Votes
alias Kritikos.Votes.{Vote, Feedback}
alias KritikosWeb.{Email, Mailer}

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
      user = Auth.get_active_user(user_id)
      user_session = %Session{user_id: user.id}

      demos = [
        {"Bathroom south", "bathroom_south", "How was overall cleanliness?",
         ["bathroom", "2019", "customer_svc"]},
        {"Bathroom north", "bathroom_north", "How was overall cleanliness?",
         ["bathroom", "2020", "customer_svc"]},
        {"Customer drinks", "drinks", "Was your order correct?", ["2020", "customer_svc"]},
        {"Email marketing", "email_marketing", "Would you recommend us to a friend?",
         ["email", "2020", "Spring"]}
      ]

      session_inserts =
        Enum.map(demos, fn {name, kw, question, tags} ->
          attrs = %{
            tags: Enum.shuffle(tags) |> Enum.map(fn t -> %{text: t} end),
            prompt_question: question,
            keyword: kw,
            name: name
          }

          Session.create_changeset(user_session, attrs) |> Repo.insert() |> elem(1)
        end)

      vote_inserts =
        Enum.map(session_inserts, fn s ->
          Enum.map(1..Enum.random(10..30), fn _ ->
            vote = Ecto.build_assoc(s, :votes, vote_level_id: Enum.random(1..3))
            Vote.create_changeset(vote, %{}) |> Repo.insert() |> elem(1)
          end)
        end)
        |> List.flatten()

      demo_feedbacks = [
        "Could have been better",
        "I enjoyed it",
        "Thanks",
        "There were some problems with my coffee"
      ]

      feedback_inserts =
        Enum.map(vote_inserts, fn v ->
          feedback = Ecto.build_assoc(v, :feedback, text: Enum.random(demo_feedbacks))
          Feedback.changeset(feedback, %{}) |> Repo.insert() |> elem(1)
        end)

      %{sessions: session_inserts, votes: vote_inserts, feedback: feedback_inserts}
    end

    def vote_random(user_id) when is_integer(user_id) do
      {:ok, vote} =
        Repo.all(from(s in Session, where: s.user_id == ^user_id, select: s.keyword))
        |> Enum.random()
        |> Votes.submit_vote(Enum.random(1..3))

      KritikosWeb.DashboardChannel.broadcast_model_update(user_id, %{vote: vote})
    end

    def vote_random(user_id, session_keyword) do
      {:ok, vote} = Votes.submit_vote(session_keyword, Enum.random(1..3))

      KritikosWeb.DashboardChannel.broadcast_model_update(user_id, %{vote: vote})
    end

    def gen_vote_random(user_id, n) do
      Enum.map(1..n, fn _ -> vote_random(user_id) end)
    end

    def gen_vote_random(user_id, session_keyword, n) do
      Enum.map(1..n, fn _ -> vote_random(user_id, session_keyword) end)
    end
  end,
  Macro.Env.location(__ENV__)
)

IO.puts("iex config loaded")
