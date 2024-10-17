defmodule SonetLib.AshPhoenix.CommonTest do
  use SonetLib.DataCase

  test "create" do
    assert SonetLib.TestIdentity.User
           |> AshPhoenix.Form.for_create(:create)
           |> AshPhoenix.Form.submit!()
  end

  test "create_with_stores" do
    assert %{stores: stores} =
             SonetLib.TestIdentity.User
             |> AshPhoenix.Form.for_create(:create_with_stores,
               params: %{
                 stores: [%{handle: "store1"}, %{handle: "store2"}]
               }
             )
             |> AshPhoenix.Form.submit!()

    assert_value Enum.map(stores, &to_string(&1.handle)) == ["store1", "store2"]
  end
end
