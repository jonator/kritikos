defmodule Kritikos.Votes.VoteLevel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vote_levels" do
    field :description, :string
    field :level, :integer
  end

  @doc false
  def changeset(vote_level, attrs) do
    vote_level
    |> cast(attrs, [:level])
    |> validate_required([:level])
  end
end
