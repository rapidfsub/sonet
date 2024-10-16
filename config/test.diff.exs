import Config

config :ash, disable_async?: true
config :sonet, token_signing_secret: "vIGKjm1kVLPEuCXC10v8pinjcdNNPV/P"

# Avoid timeouts while waiting for user input in assert_value
config :ex_unit, timeout: :infinity

config :sonet, Sonet.Repo,
  timeout: :infinity,
  ownership_timeout: :infinity

config :sonet,
  ash_domains: [
    Sonet.Accounts,
    SonetLib.Domain
  ]
