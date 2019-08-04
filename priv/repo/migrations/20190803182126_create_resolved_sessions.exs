defmodule Kritikos.Repo.Migrations.CreateResolvedSessions do
  use Ecto.Migration

  def change do
    create table(:resolved_sessions) do
      add :keyword, :string
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime
      add :host_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:resolved_sessions, [:host_id])
  end
end
