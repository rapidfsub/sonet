defmodule SonetWeb.AshJsonApi.AccountsTest do
  use SonetWeb.ConnCase

  describe "without user" do
    test "POST /api/json/user", %{conn: conn} do
      email = Fake.email()
      password = Fake.sentence()

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

    test "fail GET /api/json/user", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> get(~p"/api/json/user")

      assert json_response(conn, 403)
    end
  end

  describe "with user" do
    setup do
      email = Fake.email()
      password = Fake.sentence()

      user =
        Ashex.run_create!(Sonet.Accounts.User, :register_with_password, %{
          email: email,
          password: password,
          password_confirmation: password
        })

      %{user: user, email: email, password: password}
    end

    test "POST /api/json/user/login", %{conn: conn, email: email, password: password} do
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

    test "GET /api/json/user", %{conn: conn, user: user, email: email} do
      token = user.__metadata__.token

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(~p"/api/json/user")

      assert %{"data" => %{"attributes" => attributes}} = json_response(conn, 200)
      assert attributes["email"] == email
    end
  end
end
