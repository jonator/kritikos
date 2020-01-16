defmodule Kritikos.Repo.Migrations.CreateFeedback do
  use Ecto.Migration

  def change do
    create table(:feedback) do
      add :text, :string, null: false
      add :vote_id, references(:votes, column: :voter_number), null: false
    end

    create index(:feedback, [:vote_id])
  end
end
