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

  describe "ash_postgres" do
    test "test complex policy with nested resources" do
      assert customer = Ashex.run_create!(SevenEleven.Customer, :create, params: %{age: 20})
      assert minor = Ashex.run_create!(SevenEleven.Customer, :create, params: %{age: 14})

      assert store =
               Ashex.run_create!(SevenEleven.Store, :create,
                 params: %{open_time: ~T[15:00:00], close_time: ~T[21:00:00]}
               )

      assert product =
               Ashex.run_create!(SevenEleven.Product, :create,
                 params: %{store_id: store.id, is_adult_only: true}
               )

      assert {:error, %{}} =
               Ashex.run_update(store, :purchase,
                 actor: customer,
                 params: %{time: ~T[11:00:00], product_id: product.id}
               )

      assert {:error, %{}} =
               Ashex.run_update(store, :purchase,
                 actor: minor,
                 params: %{time: ~T[16:00:00], product_id: product.id}
               )

      assert {:ok, %{}} =
               Ashex.run_update(store, :purchase,
                 actor: customer,
                 params: %{time: ~T[16:00:00], product_id: product.id}
               )
    end
  end
end
