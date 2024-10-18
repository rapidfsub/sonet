defmodule SonetLib.Ash.Policies.CommonTest do
  use SonetLib.DataCase

  test "policy conditions are combined with and" do
    defmodule Article1 do
      use Ash.Resource,
        domain: SonetLib.TestDomain,
        authorizers: [Ash.Policy.Authorizer]

      attributes do
        uuid_v7_primary_key :id
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

    assert {:error, %{}} = Ashex.run_create(Article1, :create)
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
        domain: SonetLib.TestDomain,
        authorizers: [Ash.Policy.Authorizer],
        fragments: [
          Article2Fragment
        ]

      attributes do
        uuid_v7_primary_key :id
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

    assert Ashex.run_create!(Article2, :create)
  end

  test "not every check in a policy must pass" do
    defmodule Article3 do
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

    assert Ashex.run_create!(Article3, :create)
  end
end
