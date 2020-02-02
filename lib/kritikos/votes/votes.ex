defmodule Kritikos.Votes do
  import Ecto.Query
  alias Kritikos.Repo
  alias __MODULE__.VoteLevel
  alias Kritikos.Sessions
  alias Kritikos.Votes.{Vote, Feedback}

  def submit_vote(session_keyword, vote_level_id) do
    Sessions.get_open(session_keyword)
    |> Ecto.build_assoc(:votes)
    |> Vote.create_changeset(%{vote_level_id: vote_level_id, vote_datetime: DateTime.utc_now()})
    |> Repo.insert()
  end

  def update_vote(vote_id, attrs) do
    Repo.get(Vote, vote_id)
    |> Vote.update_changeset(attrs)
    |> Repo.update()
  end

  def update_or_submit_feedback(vote_id, feedback_text) do
    vote = Repo.get(Vote, vote_id)

    case Ecto.assoc(vote, :feedback) |> Repo.one() do
      nil -> Ecto.build_assoc(vote, :feedback)
      %Feedback{} = fb -> fb
    end
    |> Feedback.changeset(%{text: feedback_text})
    |> Repo.insert_or_update()
  end

  def vote_levels_descriptions do
    Repo.all(from(v in VoteLevel, select: {v.id, v.description})) |> Map.new()
  end
end
