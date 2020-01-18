defmodule Kritikos.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :keyword, :string, null: false
      add :name, :string
      add :prompt_question, :string
      add :start_datetime, :utc_datetime, null: false
      add :end_datetime, :utc_datetime
      add :profile_id, references(:user_profiles)
    end

    create index(:sessions, [:profile_id])
  end
end
