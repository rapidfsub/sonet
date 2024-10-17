defmodule SonetLib.AshPhoenix.CommonTest do
  use SonetLib.DataCase

  test "create" do
    assert SonetLib.TestIdentity.User
           |> AshPhoenix.Form.for_create(:create)
           |> AshPhoenix.Form.submit!()
  end
end
