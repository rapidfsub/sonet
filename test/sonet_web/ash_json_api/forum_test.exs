defmodule SonetWeb.AshJsonApi.ForumTest do
  use SonetWeb.JsonApiCase

  setup do
    password = Fake.sentence()

    account =
      Ashex.run_create!(Identity.Account, :register_with_password,
        params: %{
          email: Fake.email(),
          password: password,
          password_confirmation: password,
          username: Fake.word()
        }
      )

    ~M{account}
  end

  test "POST /api/json/article", ~M{conn, account} do
    token = account.__metadata__.token
    title = Fake.sentence()
    description = Fake.sentence()
    body = Fake.paragraph()

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post(~p"/api/json/article", %{data: %{attributes: ~M{title, description, body}}})

    assert %{"data" => ~m{attributes}} = json_response(conn, 201)
    assert ~m{^title, ^description, ^body} = attributes
  end
end
