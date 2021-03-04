defmodule Kritikos.Repo.Migrations.VotesViewed do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      add :viewed, :boolean, null: false, default: false
    end
  end
end
