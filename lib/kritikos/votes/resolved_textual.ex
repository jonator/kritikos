defmodule Kritikos.Votes.ResolvedTextual do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kritikos.Votes.Text

  schema "resolved_textual_votes" do
    field :text, :string
    field :vote_id, :id
  end

  @doc false
  def changeset(resolved_textual, attrs) do
    resolved_textual
    |> cast(attrs, [:text, :vote_id])
    |> validate_required([:text, :vote_id])
    |> foreign_key_constraint(:vote_id)
  end

  def create_all([%Text{} | _] = texts, resolved_votes) do
    resolved_texts =
      Enum.map(texts, fn text ->
        resolved_vote = Enum.find(resolved_votes, fn v -> v.voter_number == text.voter_number end)

        changeset(%__MODULE__{}, Map.from_struct(text) |> Map.merge(%{vote_id: resolved_vote.id}))
        |> apply_changes()
        |> Map.from_struct()
        |> Map.drop([:__meta__, :id])
      end)

    Kritikos.Repo.insert_all(__MODULE__, resolved_texts)
  end

  def create_all(_, []), do: []
end
