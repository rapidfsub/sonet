defmodule SonetWeb.AshJsonApi.IdentityTest do
  use SonetWeb.ConnCase

  describe "without user" do
    test "POST /api/json/user", ~M{conn} do
      email = Fake.email()
      password = Fake.sentence()
      username = Fake.word()
      bio = Fake.sentence()

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> post(~p"/api/json/user", %{
          data: %{attributes: ~M{email, password, password_confirmation: password, username, bio}}
        })

      assert %{"data" => ~m{attributes}} = json_response(conn, 201)
      assert ~m{^email, ^username, ^bio} = attributes
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
        Ashex.run_create!(Identity.Account, :register_with_password,
          params: ~M{email, password, password_confirmation: password, username, bio}
        )

      %{user: user, email: email, password: password}
    end

    test "POST /api/json/user/login", ~M{conn, user, email, password} do
      ~M{username, bio} = user

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> post(~p"/api/json/user/login", %{data: %{attributes: ~M{email, password}}})

      assert %{
               "data" => %{"attributes" => ~m{^email, ^username, ^bio}},
               "meta" => %{"token" => <<_token::binary>>}
             } = json_response(conn, 201)
    end

    test "GET /api/json/user", ~M{conn, user, email} do
      ~M{username, bio} = user
      token = user.__metadata__.token

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(~p"/api/json/user")

      assert %{"data" => ~m{attributes}} = json_response(conn, 200)
      assert ~m{^email, ^username, ^bio} = attributes
    end

    test "PATCH /api/json/user", ~M{conn, user} do
      username = Fake.word()
      bio = Fake.sentence()
      assert username != user.username
      assert bio != user.bio

      token = user.__metadata__.token

      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> patch(~p"/api/json/user", %{data: %{attributes: ~M{username, bio}}})

      id = user.id
      assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
      assert ~m{^username, ^bio} = attributes
    end

    test "GET /api/json/user/:username", ~M{conn, user} do
      conn =
        conn
        |> put_req_header("content-type", "application/vnd.api+json")
        |> get(~p"/api/json/user/#{user.username}")

      id = user.id
      assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
      assert attributes["username"] == user.username
    end
  end
end
