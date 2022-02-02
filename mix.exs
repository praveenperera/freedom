defmodule Freedom.MixProject do
  use Mix.Project

  def project do
    [
      app: :freedom,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Freedom.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def releases() do
    [
      freedom: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # phoenix
      {:phoenix, "~> 1.6"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:plug_cowboy, "~> 2.5"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},

      # db
      {:ecto_sql, "~> 3.7"},
      {:ecto_enum, "~> 1.4"},
      {:postgrex, ">= 0.0.0"},

      # utils
      {:typed_struct, "~> 0.2.1"},
      {:calendar, "~> 1.0.0"},

      # apis
      {:certifi, "~> 2.4"},
      {:castore, "~> 0.1"},
      {:ssl_verify_fun, "~> 1.1"},
      {:tesla, "~> 1.3"},
      {:hackney, "~> 1.15"},
      {:jason, "~> 1.0"},

      # auth
      {:pow, "~> 1.0.26"},
      {:argon2_elixir, "~> 2.0"},

      # phoenix helpers
      {:exgravatar, "~> 2.0"},
      {:phoenix_html_simplified_helpers, "~> 2.1"},
      {:gettext, "~> 0.11"},

      # liveview
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_live_dashboard, "~> 0.6.3"},
      {:ecto_psql_extras, "~> 0.2"},

      # metrics
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},

      # email
      {:bamboo, "~> 1.4"},

      # release
      {:libcluster, "~> 3.1"},
      {:healthchex, "~> 0.2"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "assets.deploy": [
        "cmd --cd assets npm run deploy",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end
end
