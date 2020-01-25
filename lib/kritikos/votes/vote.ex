defmodule Kritikos.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Sessions.Session
  alias Kritikos.Votes.Feedback

  schema "votes" do
    field :vote_datetime, :utc_datetime
    belongs_to :session, Session
    has_one :feedback, Feedback
    field :vote_level_id, :id
  end

  @doc false
  def create_changeset(vote, attrs) do
    now = %{DateTime.utc_now() | microsecond: {0, 0}}

    vote
    |> cast(attrs, [:session_id, :vote_level_id])
    |> validate_required([:session_id, :vote_level_id])
    |> assoc_constraint(:session)
    |> foreign_key_constraint(:vote_level_id)
    |> put_change(:vote_datetime, now)
  end

  def update_changeset(vote, attrs) do
    vote
    |> cast(attrs, [:vote_level_id, :feedback_id])
    |> foreign_key_constraint(:vote_level_id)
    |> assoc_constraint(:feedback)
  end
end
