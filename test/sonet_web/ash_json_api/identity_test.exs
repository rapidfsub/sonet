defmodule SonetWeb.AshJsonApi.IdentityTest do
  use SonetWeb.JsonApiCase

  test "POST /api/json/account", ~M{conn} do
    email = Fake.email()
    password = Fake.sentence()
    username = Fake.word()
    bio = Fake.sentence()

    conn =
      conn
      |> post(~p"/api/json/account", %{
        data: %{attributes: ~M{email, password, password_confirmation: password, username, bio}}
      })

    assert %{"data" => ~m{attributes}} = json_response(conn, 201)
    assert ~m{^email, ^username, ^bio} = attributes
  end

  test "fail GET /api/json/account", %{conn: conn} do
    conn = conn |> get(~p"/api/json/account")
    assert json_response(conn, 403)
  end

  test "POST /api/json/account/login", ~M{conn, account} do
    ~M{username, bio} = account

    conn =
      conn
      |> post(~p"/api/json/account/login", %{
        data: %{attributes: %{email: account.email, password: "password"}}
      })

    assert %{
             "data" => %{"attributes" => ~m{^username, ^bio}},
             "meta" => %{"token" => <<_token::binary>>}
           } = json_response(conn, 201)
  end

  test "GET /api/json/account", ~M{conn, account, token} do
    ~M{username, bio} = account

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> get(~p"/api/json/account")

    assert %{"data" => ~m{attributes}} = json_response(conn, 200)
    assert ~m{^username, ^bio} = attributes
  end

  test "PATCH /api/json/account", ~M{conn, account, token} do
    username = Fake.word()
    bio = Fake.sentence()
    assert username != account.username
    assert bio != account.bio

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> patch(~p"/api/json/account", %{data: %{attributes: ~M{username, bio}}})

    id = account.id
    assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
    assert ~m{^username, ^bio} = attributes
  end

  test "GET /api/json/account/:username", ~M{conn, account} do
    conn = conn |> get(~p"/api/json/account/#{account.username}")
    id = account.id
    assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
    assert attributes["username"] == account.username
  end

  test "PATCH /api/json/account/:username/follow", ~M{conn, token, account0} do
    for is_following <- [true, false, true, false] do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> patch(~p"/api/json/account/#{account0.username}/follow", %{
          data: %{attributes: ~M{is_following}}
        })

      id = account0.id
      assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
      username = account0.username
      assert ~m{^username, ^is_following} = attributes
    end
  end
end
