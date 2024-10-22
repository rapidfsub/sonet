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

  # test "create_with_stores" do
  #   assert %{stores: stores} =
  #            TestIdentity.User
  #            |> Form.for_create(:create_with_stores,
  #              params: %{
  #                "email" => Fake.email(),
  #                "stores" => [%{"handle" => "store1"}, %{"handle" => "store2"}]
  #              }
  #            )
  #            |> Form.submit!()

  #   assert_value Enum.map(stores, &to_string(&1.handle)) == ["store1", "store2"]
  # end

  describe "with user" do
    # setup do
    #   user = Ashex.seed!(TestIdentity.User, %{email: Fake.email()})

    #   stores =
    #     for i <- 1..10 do
    #       %Shopify.Store{handle: "store_#{i}", user_id: user.id}
    #     end
    #     |> Ashex.seed!()

    #   user = Ashex.load!(user, [:stores])
    #   %{user: user, stores: stores}
    # end

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

    # test "update_with_stores", %{user: user} do
    #   form =
    #     user
    #     |> Ashex.load!([:stores])
    #     |> Form.for_update(:update_with_stores, forms: [auto?: true])
    #     |> Form.to_form()

    #   old_stores = user.stores

    #   form =
    #     for i <- 1..3, reduce: form do
    #       form ->
    #         form
    #         |> Form.remove_form([:stores, 0])
    #         |> Form.add_form([:stores, -1], params: %{handle: "new_store_#{i}"})
    #     end

    #   assert %{stores: stores} =
    #            form
    #            |> Form.submit!()
    #            |> Ashex.load!([:stores])

    #   for store <- Enum.drop(stores, -3) do
    #     assert Enum.any?(old_stores, &(&1.id == store.id and &1.handle == store.handle))
    #   end
    # end
  end
end
