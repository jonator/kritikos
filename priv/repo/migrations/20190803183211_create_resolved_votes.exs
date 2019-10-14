defmodule Kritikos.Repo.Migrations.CreateResolvedVotes do
  use Ecto.Migration

  def change do
    create table(:resolved_votes) do
      add :vote_datetime, :utc_datetime
      add :session_id, references(:resolved_sessions, on_delete: :nothing)
      add :vote_level_id, references(:vote_levels, on_delete: :nothing)
      add :voter_number, :integer
    end

    create index(:resolved_votes, [:session_id])
    create index(:resolved_votes, [:vote_level_id])
  end
end
