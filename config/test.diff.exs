import Config

config :ash, disable_async?: true
config :bcrypt_elixir, log_rounds: 1
config :sonet, token_signing_secret: "vIGKjm1kVLPEuCXC10v8pinjcdNNPV/P"

# Avoid timeouts while waiting for user input in assert_value
config :ex_unit, timeout: :infinity

config :sonet, Sonet.Repo,
  timeout: :infinity,
  ownership_timeout: :infinity

config :sonet,
  ash_domains: [
    Sonet.Forum,
    Sonet.Identity,
    SonetLib.Shopify,
    SonetLib.TestDomain,
    SonetLib.TestIdentity
  ]

config :sonet,
  ecto_repos: [
    Sonet.Repo,
    SonetLib.TestRepo
  ]

config :sonet, SonetLib.TestRepo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "sonet_lib_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2
