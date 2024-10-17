defmodule SonetLib.AshPhoenix.CommonTest do
  use SonetLib.DataCase

  test "create" do
    assert TestIdentity.User
           |> Form.for_create(:create,
             params: %{
               "email" => Fake.email()
             }
           )
           |> Form.submit!()
  end

  test "create_with_stores" do
    assert %{stores: stores} =
             TestIdentity.User
             |> Form.for_create(:create_with_stores,
               params: %{
                 "email" => Fake.email(),
                 "stores" => [%{"handle" => "store1"}, %{"handle" => "store2"}]
               }
             )
             |> Form.submit!()

    assert_value Enum.map(stores, &to_string(&1.handle)) == ["store1", "store2"]
  end

  describe "with user" do
    setup do
      user = Ashex.seed!(TestIdentity.User, %{email: Fake.email()})

      stores =
        for i <- 1..10 do
          %Shopify.Store{handle: "store_#{i}", user_id: user.id}
        end
        |> Ashex.seed!()

      user = Ash.load!(user, [:stores])
      %{user: user, stores: stores}
    end

    test "update", %{user: user} do
      old_email = user.email
      assert user.email == old_email

      assert user =
               user
               |> Form.for_update(:update,
                 params: %{
                   "email" => Fake.email()
                 }
               )
               |> Form.submit!()

      refute user.email == old_email
    end

    test "update_with_stores", %{user: user} do
      form =
        user
        |> Ash.load!([:stores])
        |> Form.for_update(:update_with_stores, forms: [auto?: true])
        |> Form.to_form()

      form =
        for _ <- 1..5, reduce: form do
          form -> Form.remove_form(form, [:stores, 0])
        end

      assert %{stores: [%{}, %{}, %{}, %{}, %{}]} =
               form
               |> Form.submit!()
               |> Ash.load!([:stores])
    end
  end
end
