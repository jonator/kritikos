defmodule Kritikos.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :user_id, references(:users), null: false
      add :first_last_name, :string, null: false
      add :substitute_session_keyword, :string
      add :redirect_count, :integer, null: false

      timestamps()
    end

    create index(:user_profiles, [:user_id])
  end
end
