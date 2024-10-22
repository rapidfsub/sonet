defmodule SonetWeb.AshJsonApi.ForumTest do
  use SonetWeb.JsonApiCase

  test "POST /api/json/article", ~M{conn, account} do
    token = account.__metadata__.token
    title = Fake.sentence()
    description = Fake.sentence()
    body = Fake.paragraph()

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post(~p"/api/json/article?#{[include: "author"]}", %{
        data: %{attributes: ~M{title, description, body}}
      })

    assert ~m{data, included} = json_response(conn, 201)
    assert %{"attributes" => ~m{^title, ^description, ^body}} = data

    with ~M{id, username} = account do
      assert [%{"id" => ^id, "attributes" => ~m{^username}}] = included
    end
  end
end
