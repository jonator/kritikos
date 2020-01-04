defmodule Kritikos.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions.Session
  alias Kritikos.Votes.Feedback

  @primary_key {:voter_number, :id, autogenerate: true}

  schema "votes" do
    field :vote_datetime, :utc_datetime
    belongs_to :session, Session
    has_one :feedback, Feedback, foreign_key: :voter_number
    field :vote_level_id, :id
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:session_id, :vote_level_id, :vote_datetime, :voter_number, :feedback_id])
    |> validate_required([
      :session_id,
      :vote_level_id,
      :vote_datetime,
      :voter_number
    ])
    |> assoc_constraint(:session)
    |> assoc_constraint(:feedback)
    |> foreign_key_constraint(:vote_level_id)
  end

  def update_changeset(vote, attrs) do
    vote
    |> cast(attrs, [:vote_level_id, :feedback_id])
    |> foreign_key_constraint(:vote_level_id)
    |> assoc_constraint(:feedback)
  end
end
