defmodule Kritikos.MixProject do
  use Mix.Project

  def project do
    [
      app: :kritikos,
      version: "0.1.21",
      elixir: "~> 1.12.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        kritikos: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          include_erts: true
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kritikos.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :stripity_stripe]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.1"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:comeonin, ">= 4.1.2"},
      {:bcrypt_elixir, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.1"},
      {:phoenix_inline_svg, "~> 1.3.1"},
      {:eqrcode, "~> 0.1.6"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:phoenix_live_dashboard, "~> 0.1"},
      {:bamboo, "~> 2.0"},
      {:bamboo_phoenix, "~> 1.0"},
      # to get billing portal
      {:stripity_stripe,
       git: "https://github.com/code-corps/stripity_stripe",
       ref: "337807d3f3ee8ac419ce97a684620cd8df0195d8"},
      {:pdf_generator, "~> 0.6.2"},
      {:sneeze, "~> 1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "ecto.drop",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "run priv/repo/seeds.exs",
        "test"
      ]
    ]
  end
end
