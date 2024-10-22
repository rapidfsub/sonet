defmodule Sonet.Identity.AccountTest do
  use Sonet.DataCase
  doctest Sonet.Identity.Account

  test "follow", ~M{account, account0} do
    for is_following <- [true, false, false, true, true, false] do
      assert ~M{^is_following} =
               Ashex.run_update!(account0, :follow, params: ~M{is_following}, actor: account)
    end
  end
end
