defmodule SonetWeb.AshJsonApiRouter do
  use SonetWeb.Prelude

  use AshJsonApi.Router,
    domains: [
      Identity
    ],
    open_api: "/open_api",
    open_api_servers: ["/api/json"],
    modify_open_api: {__MODULE__, :modify_open_api, []}

  def modify_open_api(%OpenApiSpex.OpenApi{} = spec, _, _) do
    schemes = %{"authorization" => %OpenApiSpex.SecurityScheme{type: "http", scheme: "bearer"}}
    components = %{spec.components | securitySchemes: schemes}
    security = [%{"authorization" => []}]

    paths =
      for {path, path_item} <- spec.paths, into: %{} do
        "/api/json" <> compact_path = path
        {compact_path, path_item}
      end

    ~M{spec | components, security, paths}
  end
end
