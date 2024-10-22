defmodule SonetLib.Ash.Policies.CommonTest do
  use SonetLib.DataCase

  test "policy conditions are combined with and" do
    defmodule Object1 do
      use Ash.Resource,
        domain: SonetLib.TestDomain,
        authorizers: [Ash.Policy.Authorizer]

      attributes do
        uuid_v7_primary_key :id
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

    assert {:error, %{}} = Ashex.run_create(Object1, :create)
  end

  test "resource policies preced fragment policies" do
    defmodule Object2Fragment do
      use Spark.Dsl.Fragment,
        of: Ash.Resource,
        authorizers: [Ash.Policy.Authorizer]

      policies do
        policy always() do
          authorize_if never()
        end
      end
    end

    defmodule Object2 do
      use Ash.Resource,
        domain: SonetLib.TestDomain,
        authorizers: [Ash.Policy.Authorizer],
        fragments: [
          Object2Fragment
        ]

      attributes do
        uuid_v7_primary_key :id
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

    assert Ashex.run_create!(Object2, :create)
  end

  test "not every check in a policy must pass" do
    defmodule Object3 do
      use Ash.Resource,
        domain: SonetLib.TestDomain,
        authorizers: [Ash.Policy.Authorizer]

      attributes do
        uuid_v7_primary_key :id
      end

      actions do
        defaults [:read, :destroy, create: :*, update: :*]
      end

      policies do
        policy always() do
          authorize_if always()
          authorize_if never()
        end
      end
    end

    assert Ashex.run_create!(Object3, :create)
  end
end
