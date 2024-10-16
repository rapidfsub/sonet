defmodule SonetWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [
      Sonet.Accounts
    ],
    open_api: "/open_api"
end
