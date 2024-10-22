defmodule SonetWeb.JsonApiCase do
  use ExUnit.CaseTemplate
  use SonetWeb.TestPrelude

  using do
    quote do
      # The default endpoint for testing
      @endpoint SonetWeb.Endpoint

      use SonetWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import unquote(__MODULE__)

      # added
      import AssertValue
      use SonetWeb.TestPrelude
    end
  end

  setup tags do
    Sonet.DataCase.setup_sandbox(tags)

    conn =
      Conn.build_test_conn()
      |> Conn.put_req_header("content-type", "application/vnd.api+json")

    ~M{conn}
  end

  setup do
    account = insert!(Identity.Account, variant: :with_token)
    token = account.__metadata__.token
    account0 = insert!(Identity.Account)
    ~M{account, token, account0}
  end
end
