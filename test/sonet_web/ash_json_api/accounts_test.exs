defmodule SonetWeb.AshJsonApi.AccountsTest do
  use SonetWeb.ConnCase

  test "POST /api/json/user", %{conn: conn} do
    email = Faker.Internet.email()
    password = Faker.Lorem.sentence()

    conn =
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

  test "POST /api/json/user/login", %{conn: conn} do
    email = Faker.Internet.email()
    password = Faker.Lorem.sentence()

    Sonet.Accounts.User
    |> Ash.Changeset.for_create(:register_with_password, %{
      email: email,
      password: password,
      password_confirmation: password
    })
    |> Ash.create!()

    conn =
      conn
      |> put_req_header("content-type", "application/vnd.api+json")
      |> post(~p"/api/json/user/login", %{
        data: %{
          attributes: %{
            email: email,
            password: password
          }
        }
      })

    assert %{
             "data" => %{"attributes" => %{"email" => ^email}},
             "meta" => %{"token" => <<_token::binary>>}
           } = json_response(conn, 201)
  end
end
