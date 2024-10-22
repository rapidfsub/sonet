defmodule SonetLib.Ash.CommonTest do
  use SonetLib.DataCase

  test "test purchase" do
    assert customer = Ashex.run_create!(SevenEleven.Customer, :create, params: %{age: 20})
    assert minor = Ashex.run_create!(SevenEleven.Customer, :create, params: %{age: 14})

    assert store =
             Ashex.run_create!(SevenEleven.Store, :create,
               params: %{open_time: ~T[15:00:00], close_time: ~T[21:00:00]}
             )

    assert product =
             Ashex.run_create!(SevenEleven.Product, :create,
               params: %{store_id: store.id, is_adult_only: true}
             )

    assert {:error, %{}} =
             Ashex.run_update(store, :purchase,
               actor: customer,
               params: %{time: ~T[11:00:00], product_id: product.id}
             )

    assert {:error, %{}} =
             Ashex.run_update(store, :purchase,
               actor: minor,
               params: %{time: ~T[16:00:00], product_id: product.id}
             )

    assert {:ok, %{}} =
             Ashex.run_update(store, :purchase,
               actor: customer,
               params: %{time: ~T[16:00:00], product_id: product.id}
             )
  end
end
