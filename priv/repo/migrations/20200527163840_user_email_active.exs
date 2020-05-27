defmodule Kritikos.Repo.Migrations.UserEmailActive do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_email_active, :boolean, null: false, default: false
    end
  end
end
