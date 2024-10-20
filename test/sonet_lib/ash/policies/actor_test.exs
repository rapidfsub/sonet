defmodule SonetLib.Ash.Policies.ActorTest do
  use SonetLib.DataCase

  defmodule Account do
    use Ash.Resource,
      domain: SonetLib.TestDomain,
      authorizers: [Ash.Policy.Authorizer]

    attributes do
      uuid_v7_primary_key :id
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]

      read :get_current_account, get?: true
    end

    policies do
      bypass action(:read) do
        authorize_if always()
      end

      policy action(:get_current_account) do
        authorize_if expr(^actor(:id) == id)
      end
    end
  end

  setup do
    data =
      for _ <- 1..5 do
        %{}
      end

    [account | _] = accounts = Ashex.seed!(Account, data)
    ~M{accounts, account}
  end

  test "filter by actor", ~M{accounts, account} do
    id = account.id
    assert Ashex.set_data_and_read!(Account, :read, accounts) |> length == 5

    assert ~M{^id} =
             Ashex.set_data_and_read_one!(Account, :get_current_account, accounts, actor: account)
  end
end
