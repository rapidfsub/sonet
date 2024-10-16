defmodule SonetWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [
      Sonet.Accounts
    ],
    open_api: "/open_api",
    modify_open_api: {__MODULE__, :modify_open_api, []}

  def modify_open_api(%OpenApiSpex.OpenApi{} = spec, _, _) do
    schemes = %{"authorization" => %OpenApiSpex.SecurityScheme{type: "http", scheme: "bearer"}}
    components = %{spec.components | securitySchemes: schemes}
    %{spec | components: components, security: [%{"authorization" => []}]}
  end
end
