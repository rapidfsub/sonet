defmodule Sonet.Identity.AccountTest do
  use Sonet.DataCase
  doctest Sonet.Identity.Account

  test "a" do
    [a1, a2] =
      for _ <- 1..2 do
        email = Fake.email()
        username = Fake.word()
        password = Fake.sentence()

        Ashex.run_create!(Identity.Account, :register_with_password,
          params: ~M{email, username, password, password_confirmation: password}
        )
      end

    for is_following <- [true, false, true, false] do
      assert ~M{^is_following} =
               Ashex.run_update!(a1, :follow, params: ~M{is_following}, actor: a2)
    end
  end
end
