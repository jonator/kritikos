defmodule Kritikos.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :first_last_name, :string, null: false
      add :password_hash, :string, null: false
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
