defmodule Kritikos.Repo.Migrations.CreateResolvedTextualVotes do
  use Ecto.Migration

  def change do
    create table(:resolved_textual_votes) do
      add :text, :string
      add :voter_number, :integer
      add :vote, references(:resolved_votes, on_delete: :nothing)

      timestamps()
    end

    create index(:resolved_textual_votes, [:vote])
  end
end
