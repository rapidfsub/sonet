defmodule SonetWeb.AshJsonApi.AccountsTest do
  use SonetWeb.ConnCase

  describe "without user" do
    test "POST /api/json/user", %{conn: conn} do
      email = Fake.email()
      password = Fake.sentence()
      username = Fake.word()
      bio = Fake.sentence()

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> post(~p"/api/json/user", %{
          data: %{
            attributes: %{
              email: email,
              password: password,
              password_confirmation: password,
              username: username,
              bio: bio
            }
          }
        })

      assert %{"data" => %{"attributes" => attributes}} = json_response(conn, 201)

      assert %{"email" => ^email, "username" => ^username, "bio" => ^bio} =
               Map.take(attributes, ["email", "username", "bio"])
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
      username = Fake.word()
      bio = Fake.sentence()

      user =
        Ashex.run_create!(Accounts.User, :register_with_password,
          params: %{
            email: email,
            password: password,
            password_confirmation: password,
            username: username,
            bio: bio
          }
        )

      %{user: user, email: email, password: password}
    end

    test "POST /api/json/user/login", %{
      conn: conn,
      user: %{username: username, bio: bio},
      email: email,
      password: password
    } do
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
               "data" => %{
                 "attributes" => %{"email" => ^email, "username" => ^username, "bio" => ^bio}
               },
               "meta" => %{"token" => <<_token::binary>>}
             } = json_response(conn, 201)
    end

    test "GET /api/json/user", %{
      conn: conn,
      user: %{username: username, bio: bio} = user,
      email: email
    } do
      token = user.__metadata__.token

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(~p"/api/json/user")

      assert %{"data" => %{"attributes" => attributes}} = json_response(conn, 200)

      assert %{"email" => ^email, "username" => ^username, "bio" => ^bio} =
               Map.take(attributes, ["email", "username", "bio"])
    end
  end
end
