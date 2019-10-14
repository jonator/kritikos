defmodule Kritikos.Votes.ResolvedVote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Votes.Vote

  schema "resolved_votes" do
    field :vote_datetime, :utc_datetime
    field :session_id, :id
    field :vote_level_id, :id
    field :voter_number, :integer
  end

  @doc false
  def changeset(resolved_vote, attrs) do
    resolved_vote
    |> cast(attrs, [:session_id, :vote_level_id, :vote_datetime, :voter_number])
    |> validate_required([:session_id, :vote_level_id, :vote_datetime, :voter_number])
    |> foreign_key_constraint(:session_id)
    |> foreign_key_constraint(:vote_level_id)
  end

  def create_all(session_id, [%Vote{} | _] = votes) do
    resolved_votes =
      Enum.map(votes, fn vote ->
        changeset(%__MODULE__{}, Map.from_struct(vote) |> Map.merge(%{session_id: session_id}))
        |> apply_changes()
        |> Map.from_struct()
        |> Map.drop([:__meta__, :id])
      end)

    Kritikos.Repo.insert_all(__MODULE__, resolved_votes, returning: true)
  end
end
