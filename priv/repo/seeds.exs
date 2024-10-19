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

user_data =
  [
    %{email: "arnaldo2002@example.org", username: "Timeless Vapes"},
    %{email: "myrna.maggio@example.net", username: "Colorado Cannabis Company"},
    %{email: "haylee1965@example.com", username: "CI Wholesale"},
    %{email: "warren2094@example.com", username: "Jetty Extracts"},
    %{email: "myrtice2094@example.org", username: "Bloom Farms"},
    %{email: "ardith_schulist@example.org", username: "THC Factory"},
    %{email: "antwon.hahn@example.org", username: "Oil Stix"},
    %{email: "wilton2002@example.net", username: "Caviar Gold"},
    %{email: "josue_prohaska@example.net", username: "Shore Natural RX"},
    %{email: "lola.jakubowski@example.net", username: "Legal Drinks"}
  ]

for params <- user_data do
  params = Map.merge(params, %{password: "password", password_confirmation: "password"})
  Ashex.run_create!(Accounts.User, :register_with_password, params: params)
end
