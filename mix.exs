defmodule Sonet.MixProject do
  use Mix.Project

  def project do
    [
      app: :sonet,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      # added
      consolidate_protocols: Mix.env() not in [:dev, :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Sonet.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:bcrypt_elixir, ">= 0.0.0"},
      {:faker, ">= 0.0.0"},
      {:slugify, ">= 0.0.0"},
      {:tiny_maps, ">= 0.0.0"},
      # ash deps
      {:ash, ">= 0.0.0"},
      {:ash_archival, ">= 0.0.0"},
      {:ash_authentication, ">= 0.0.0"},
      {:ash_authentication_phoenix, ">= 0.0.0"},
      {:ash_json_api, ">= 0.0.0"},
      {:ash_phoenix, ">= 0.0.0"},
      {:ash_postgres, ">= 0.0.0"},
      {:igniter, ">= 0.0.0"},
      {:open_api_spex, ">= 0.0.0"},
      {:picosat_elixir, ">= 0.0.0"},
      {:redoc_ui_plug, ">= 0.0.0"},
      # dev deps
      {:assert_value, ">= 0.0.0", only: [:dev, :test]},
      {:smokestack, ">= 0.0.0", only: [:test]},
      # phoenix deps
      {:phoenix, ">= 0.0.0"},
      {:phoenix_ecto, ">= 0.0.0"},
      {:ecto_sql, ">= 0.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, ">= 0.0.0"},
      {:phoenix_live_reload, ">= 0.0.0", only: :dev},
      # TODO bump on release to {:phoenix_live_view, "~> 1.0.0"},
      {:phoenix_live_view, "~> 1.0.0-rc.1", override: true},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_live_dashboard, ">= 0.0.0"},
      {:esbuild, ">= 0.0.0", runtime: Mix.env() == :dev},
      {:tailwind, ">= 0.0.0", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, ">= 0.0.0"},
      {:finch, ">= 0.0.0"},
      {:telemetry_metrics, ">= 0.0.0"},
      {:telemetry_poller, ">= 0.0.0"},
      {:gettext, ">= 0.0.0"},
      {:jason, ">= 0.0.0"},
      {:dns_cluster, ">= 0.0.0"},
      {:bandit, ">= 0.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.force_drop", "ecto.setup"],
      "ecto.force_drop": ["ecto.drop --force-drop"],
      # test: ["ash.setup --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind sonet", "esbuild sonet"],
      "assets.deploy": [
        "tailwind sonet --minify",
        "esbuild sonet --minify",
        "phx.digest"
      ],
      "ash.setup": ["ash.setup", "run priv/repo/seeds.exs"]
    ]
  end
end
