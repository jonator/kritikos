defmodule Kritikos.Votes.ResolvedTextual do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resolved_textual_votes" do
    field :text, :string
    field :voter_number, :integer
    field :vote, :id

    timestamps()
  end

  @doc false
  def changeset(resolved_textual, attrs) do
    resolved_textual
    |> cast(attrs, [:text, :voter_number])
    |> validate_required([:text, :voter_number])
  end
end
