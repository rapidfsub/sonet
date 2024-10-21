# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sonet.Repo.insert!(%Sonet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
use Sonet.Prelude

account_data = [
  %{email: "arnaldo2002@example.org", username: "Timeless Vapes"},
  %{email: "myrna.maggio@example.net", username: "Colorado Cannabis Company"},
  %{email: "haylee1965@example.com", username: "CI Wholesale"},
  %{email: "warren2094@example.com", username: "Jetty Extracts"},
  %{email: "myrtice2094@example.org", username: "Bloom Farms"}
]

[a1, a2 | [a3, a4, _a5] = accounts] =
  for params <- account_data do
    params = Map.merge(params, %{password: "password", password_confirmation: "password"})
    Ashex.run_create!(Identity.Account, :register_with_password, params: params)
  end

for actor <- accounts do
  Ashex.run_update!(a1, :follow, actor: actor, params: %{is_following: true})
  Ashex.run_update!(a2, :follow, actor: actor, params: %{is_following: true})
end

Ashex.destroy!(a1, actor: a1)
Ashex.destroy!(a3, actor: a3)
