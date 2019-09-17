defmodule Kritikos.ReleaseTasks do
  @repos Application.get_env(Kritikos, :ecto_repos)

  def migrate_database do
    case Application.ensure_all_started(:kritikos) do
      {:ok, _app_list} ->
        Enum.each(@repos, &run_migrations_for/1)

      {:error, {_app, _term}} ->
        IO.puts(:stderr, "Migration failed; apps not started")
    end
  end

  defp run_migrations_for(repo) do
    app = Keyword.get(repo.config(), :otp_app)
    IO.puts("Running migrations for #{app}")
    migrations_path = priv_path_for(repo, "migrations")
    IO.inspect(migrations_path)
    Ecto.Migrator.run(repo, migrations_path, :up, all: true)
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
