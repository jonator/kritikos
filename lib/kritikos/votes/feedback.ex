defmodule Kritikos.Votes.Feedback do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Votes.Vote

  schema "feedback" do
    field :text, :string
    belongs_to :vote, Vote, references: :voter_number, foreign_key: :voter_number
  end

  @doc false
  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, [:text, :voter_number])
    |> validate_required([:text, :voter_number])
    |> assoc_constraint(:vote)
  end
end
