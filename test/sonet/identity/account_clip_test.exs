defmodule Sonet.Identity.AccountClipTest do
  use Sonet.DataCase
  doctest Sonet.Identity.AccountClip

  test "craete_or_unarchive" do
    [a1, a2] =
      for _ <- 1..2 do
        Ashex.run_create!(Identity.Account, :register_with_password,
          params: %{
            email: Fake.email(),
            password: "password",
            password_confirmation: "password",
            username: Fake.word()
          }
        )
      end

    assert %{id: clip_id} =
             clip =
             Ashex.run_create!(Identity.AccountClip, :create_or_unarchive,
               actor: a1,
               params: %{
                 target_id: a2.id
               }
             )

    assert Ashex.destroy!(clip, actor: a1)
    assert {:error, %{}} = Ashex.get(Identity.AccountClip, clip_id)

    assert %{id: ^clip_id} =
             Ashex.run_create!(Identity.AccountClip, :create_or_unarchive,
               actor: a1,
               params: %{
                 target_id: a2.id
               }
             )
  end
end
