defmodule Kritikos.Votes.Feedback do
  @moduledoc """
  Defines textual Kritikos feedback schema associated with a Kritikos vote.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Votes.Vote

  schema "feedback" do
    field :text, :string
    belongs_to :vote, Vote
  end

  @doc false
  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, [:text, :vote_id])
    |> validate_required([:text, :vote_id])
    |> assoc_constraint(:vote)
  end
end
