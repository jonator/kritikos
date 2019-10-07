defmodule Kritikos.Votes.ResolvedVote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Votes.Vote

  schema "resolved_votes" do
    field :vote_datetime, :utc_datetime
    field :session_id, :id
    field :vote_level_id, :id
    field :voter_number, :integer

    timestamps()
  end

  @doc false
  def changeset(resolved_vote, attrs) do
    resolved_vote
    |> cast(attrs, [:session_id, :vote_level_id, :vote_datetime])
    |> validate_required([:session_id, :vote_level_id, :vote_datetime])
    |> assoc_constraint(:resolved_session)
    |> assoc_constraint(:vote_level)
  end

  def create_all(session_id, [%Vote{} | _] = votes) do
    resolved_votes =
      Enum.map(votes, fn vote ->
        cast(%__MODULE__{}, %{session_id: session_id}, [:session_id])
        |> changeset(Map.from_struct(vote))
        |> apply_changes()
      end)

    Kritikos.Repo.insert_all(__MODULE__, resolved_votes)
  end
end
