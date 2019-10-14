defmodule Kritikos.Repo.Migrations.CreateResolvedTextualVotes do
  use Ecto.Migration

  def change do
    create table(:resolved_textual_votes) do
      add :text, :string
      add :vote_id, references(:resolved_votes, on_delete: :nothing)
    end

    create index(:resolved_textual_votes, [:vote_id])
  end
end
