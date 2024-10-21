defmodule SonetWeb.AshJsonApi.IdentityTest do
  use SonetWeb.JsonApiCase

  describe "without account" do
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
  end

  describe "with account" do
    setup do
      email = Fake.email()
      password = Fake.sentence()
      username = Fake.word()
      bio = Fake.sentence()

      influencer =
        Ashex.run_create!(Identity.Account, :register_with_password,
          params: ~M{email, password, password_confirmation: password, username, bio}
        )

      email = Fake.email()
      password = Fake.sentence()
      username = Fake.word()
      bio = Fake.sentence()

      account =
        Ashex.run_create!(Identity.Account, :register_with_password,
          params: ~M{email, password, password_confirmation: password, username, bio}
        )

      ~M{account, email, password, influencer}
    end

    test "POST /api/json/account/login", ~M{conn, account, email, password} do
      ~M{username, bio} = account

      conn =
        conn
        |> post(~p"/api/json/account/login", %{data: %{attributes: ~M{email, password}}})

      assert %{
               "data" => %{"attributes" => ~m{^email, ^username, ^bio}},
               "meta" => %{"token" => <<_token::binary>>}
             } = json_response(conn, 201)
    end

    test "GET /api/json/account", ~M{conn, account, email} do
      ~M{username, bio} = account
      token = account.__metadata__.token

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(~p"/api/json/account")

      assert %{"data" => ~m{attributes}} = json_response(conn, 200)
      assert ~m{^email, ^username, ^bio} = attributes
    end

    test "PATCH /api/json/account", ~M{conn, account} do
      username = Fake.word()
      bio = Fake.sentence()
      assert username != account.username
      assert bio != account.bio

      token = account.__metadata__.token

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> patch(~p"/api/json/account", %{data: %{attributes: ~M{username, bio}}})

      id = account.id
      assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
      assert ~m{^username, ^bio} = attributes
    end

    test "GET /api/json/profile/:username", ~M{conn, account} do
      conn = conn |> get(~p"/api/json/profile/#{account.username}")
      id = account.id
      assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
      assert attributes["username"] == account.username
    end

    test "PATCH /api/json/profile/:username/follow", ~M{conn, account, influencer} do
      token = account.__metadata__.token

      for is_following <- [true, false, true, false] do
        conn =
          conn
          |> put_req_header("authorization", "Bearer #{token}")
          |> patch(~p"/api/json/profile/#{influencer.username}/follow", %{
            data: %{attributes: ~M{is_following}}
          })

        id = influencer.id
        assert %{"data" => ~m{^id, attributes}} = json_response(conn, 200)
        username = influencer.username
        assert ~m{^username, ^is_following} = attributes
      end
    end
  end
end
