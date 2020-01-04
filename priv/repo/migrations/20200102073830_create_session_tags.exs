defmodule Kritikos.Repo.Migrations.CreateSessionTags do
  use Ecto.Migration

  def change do
    create table(:session_tags) do
      add :text, :string, null: false
      add :session_id, references(:sessions, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:session_tags, [:session_id])
  end
end
