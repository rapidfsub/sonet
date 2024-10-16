defmodule SonetWeb.AshJsonApi.AccountsTest do
  use SonetWeb.ConnCase

  test "POST /api/json/user", %{conn: conn} do
    email = Faker.Internet.email()
    password = Faker.Lorem.sentence()

    assert conn =
             conn
             |> put_req_header("content-type", "application/vnd.api+json")
             |> post(~p"/api/json/user", %{
               data: %{
                 attributes: %{
                   email: email,
                   password: password,
                   password_confirmation: password
                 }
               }
             })

    assert %{"data" => %{"attributes" => attributes}} = json_response(conn, 201)
    assert attributes["email"] == email
  end
end
