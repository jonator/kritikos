defmodule Kritikos.Votes do
  @moduledoc """
  Fetch and update Kritikos Votes.
  """
  alias Kritikos.Repo
  alias __MODULE__.Queries
  alias Kritikos.Helpers
  alias Kritikos.Sessions
  alias Kritikos.Votes.{Vote, Feedback}

  def get_vote(vote_id, opts \\ [])
  def get_vote(vote_id, opts), do: Helpers.get_schema(Vote, vote_id, opts)

  def submit_vote(session_keyword, vote_level_id) do
    case Sessions.get_open(session_keyword) do
      nil ->
        {:error, "#{session_keyword} is closed or doesn't exist"}

      session ->
        session
        |> Ecto.build_assoc(:votes)
        |> Vote.create_changeset(%{
          vote_level_id: vote_level_id,
          vote_datetime: DateTime.utc_now()
        })
        |> Repo.insert()
    end
  end

  def update_vote(vote_id, attrs) do
    vote = Repo.get(Vote, vote_id) |> Repo.preload(:session)

    if Sessions.get_open(vote.session.keyword) == nil do
      {:error, "associated session closed"}
    else
      Repo.get(Vote, vote_id)
      |> Vote.update_changeset(attrs)
      |> Repo.update()
    end
  end

  def update_or_submit_feedback(vote_id, feedback_text) do
    vote =
      Repo.get(Vote, vote_id)
      |> Repo.preload(:session)

    if vote == nil || Sessions.get_open(vote.session.keyword) == nil do
      {:error, "associated session is closed"}
    else
      case Ecto.assoc(vote, :feedback) |> Repo.one() do
        nil -> Ecto.build_assoc(vote, :feedback)
        %Feedback{} = fb -> fb
      end
      |> Feedback.changeset(%{text: feedback_text})
      |> Repo.insert_or_update()
    end
  end

  def include_assoc(%Vote{} = vote, key), do: Repo.preload(vote, key)

  def update_vote_ids_viewed(vote_ids),
    do: Queries.all_with_ids(vote_ids) |> Repo.update_all(set: [viewed: true])
end
