defmodule Kritikos.Repo.Migrations.CreateVoteLevels do
  use Ecto.Migration

  def change do
    create table(:vote_levels) do
      add :level, :integer
      add :description, :string
    end
  end
end
