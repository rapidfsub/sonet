defmodule SonetLib.AshPhoenix.CommonTest do
  use SonetLib.DataCase

  test "create" do
    assert SonetLib.TestIdentity.User
           |> AshPhoenix.Form.for_create(:create)
           |> AshPhoenix.Form.submit!()
  end

  test "create_with_stores" do
    assert %{stores: [%{}, %{}]} =
             SonetLib.TestIdentity.User
             |> AshPhoenix.Form.for_create(:create_with_stores,
               params: %{
                 stores: [%{}, %{}]
               }
             )
             |> AshPhoenix.Form.submit!()
  end
end
