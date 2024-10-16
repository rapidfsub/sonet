defmodule SonetLib.Ash.PoliciesTest do
  use Sonet.DataCase

  test "policy conditions are combined with and" do
    defmodule Article do
      use Ash.Resource,
        domain: SonetLib.Domain,
        authorizers: [Ash.Policy.Authorizer]

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false
      end

      actions do
        defaults [:read, :destroy, create: :*, update: :*]
      end

      policies do
        policy [always(), never()] do
          authorize_if always()
        end
      end
    end

    assert {:error, %{}} =
             Article
             |> Ash.Changeset.for_create(:create)
             |> Ash.create()
  end
end
