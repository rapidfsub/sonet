[
  import_deps: [
    :ash,
    :ash_archival,
    :ash_authentication,
    :ash_authentication_phoenix,
    :ash_json_api,
    :ash_postgres,
    :assert_value,
    :ecto,
    :ecto_sql,
    :phoenix
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Spark.Formatter, Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
