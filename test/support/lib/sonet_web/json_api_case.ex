defmodule SonetWeb.JsonApiCase do
  use ExUnit.CaseTemplate
  use SonetWeb.Prelude

  using do
    quote do
      # The default endpoint for testing
      @endpoint SonetWeb.Endpoint

      use SonetWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import SonetWeb.ConnCase

      # added
      import AssertValue
      use SonetWeb.Prelude
    end
  end

  setup tags do
    Sonet.DataCase.setup_sandbox(tags)

    conn =
      Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("content-type", "application/vnd.api+json")

    ~M{conn}
  end
end
