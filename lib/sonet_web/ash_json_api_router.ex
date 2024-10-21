defmodule SonetWeb.AshJsonApiRouter do
  use SonetWeb.Prelude

  use AshJsonApi.Router,
    domains: [
      Identity
    ],
    open_api: "/open_api",
    modify_open_api: {__MODULE__, :modify_open_api, []}

  @prefix "/api/json"
  def modify_open_api(%OpenApiSpex.OpenApi{} = spec, _, _) do
    schemes = %{"authorization" => %OpenApiSpex.SecurityScheme{type: "http", scheme: "bearer"}}
    components = %{spec.components | securitySchemes: schemes}
    security = [%{"authorization" => []}]

    [%OpenApiSpex.Server{} = server] = spec.servers
    url = Path.join([server.url, @prefix])
    servers = [%{server | url: url}]

    paths =
      Map.new(spec.paths, fn {k, v} ->
        {String.replace_prefix(k, @prefix, ""), v}
      end)

    ~M{spec | components, security, servers, paths}
  end
end
