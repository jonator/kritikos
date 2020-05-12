defmodule Kritikos.Repo.Migrations.DeleteSessions do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      add :is_active, :boolean, null: false, default: true
    end
  end
end
