defmodule Kritikos.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :vote_datetime, :utc_datetime, null: false
      add :session_id, references(:sessions), null: false
      add :vote_level_id, references(:vote_levels), null: false
    end

    create index(:votes, [:session_id])
  end
end
