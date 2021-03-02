defmodule Kritikos.ReleaseTasks do
  @moduledoc """
  Defines routines to be run during the app release lifecycle.
  """
  @app :kritikos
  alias Kritikos.Repo
  alias Kritikos.Votes.VoteLevel
  require Logger

  def migrate_database do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))

      if repo == Kritikos.Repo do
        Ecto.Migrator.with_repo(repo, &seeds_up/1)
      end
    end
  end

  def seeds_up(_) do
    if seeds_down(nil) do
      try do
        Repo.query("CREATE TABLE IF NOT EXISTS vote_levels")
        Repo.insert!(%VoteLevel{description: "frown"})
        Repo.insert!(%VoteLevel{description: "neutral"})
        Repo.insert!(%VoteLevel{description: "happy"})
      rescue
        _ -> Logger.warn("Seeds already up")
      end
    end
  end

  def reset_database do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, all: true))

      if repo == Kritikos.Repo do
        Ecto.Migrator.with_repo(repo, &seeds_down/1)
      end
    end

    _ = migrate_database()
  end

  def seeds_down(_) do
    if length(Repo.all(VoteLevel)) != 3 do
      try do
        Repo.delete_all(VoteLevel)
        Repo.query("ALTER SEQUENCE vote_levels_id_seq RESTART")
        true
      rescue
        _ ->
          Logger.warn("Seeds shouldn't be dropped")
          false
      end
    else
      false
    end
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
