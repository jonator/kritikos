defmodule Kritikos.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes, primary_key: false) do
      add :voter_number, :id, null: false, primary_key: true
      add :vote_datetime, :utc_datetime, null: false
      add :session_id, references(:sessions), null: false
      add :vote_level_id, references(:vote_levels), null: false
    end

    create index(:votes, [:session_id])
  end
end
