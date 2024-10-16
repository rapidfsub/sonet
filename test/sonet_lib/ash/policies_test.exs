defmodule SonetLib.Ash.PoliciesTest do
  use Sonet.DataCase

  test "policy conditions are combined with and" do
    defmodule Article1 do
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
             Article1
             |> Ash.Changeset.for_create(:create)
             |> Ash.create()
  end

  test "resource policies preced fragment policies" do
    defmodule Article2Fragment do
      use Spark.Dsl.Fragment,
        of: Ash.Resource,
        authorizers: [Ash.Policy.Authorizer]

      policies do
        policy always() do
          authorize_if never()
        end
      end
    end

    defmodule Article2 do
      use Ash.Resource,
        domain: SonetLib.Domain,
        authorizers: [Ash.Policy.Authorizer],
        fragments: [
          Article2Fragment
        ]

      attributes do
        uuid_primary_key :id
        attribute :title, :string
      end

      actions do
        defaults [:read, :destroy, create: :*, update: :*]
      end

      policies do
        bypass always() do
          authorize_if always()
        end
      end
    end

    assert Article2
           |> Ash.Changeset.for_create(:create)
           |> Ash.create!()
  end
end
