defmodule SonetLib.Ash.Policies.CommonTest do
  use SonetLib.DataCase

  test "policy conditions are combined with and" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain,
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
        domain: TestDomain,
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
        domain: TestDomain,
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
    setup do
      # create customers
      customer = Ashex.run_create!(SevenEleven.Customer, :create, params: %{age: 20})
      minor = Ashex.run_create!(SevenEleven.Customer, :create, params: %{age: 14})

      # create store
      store =
        Ashex.run_create!(SevenEleven.Store, :create,
          params: %{open_time: ~T[15:00:00], close_time: ~T[21:00:00]}
        )

      # create product
      product =
        Ashex.run_create!(SevenEleven.Product, :create,
          params: %{store_id: store.id, is_adult_only: true}
        )

      # add inventory to store
      inventory =
        Ashex.run_create!(SevenEleven.Inventory, :create,
          params: %{store_id: store.id, product_id: product.id, count: 10}
        )

      ~M{customer, minor, store, product, inventory}
    end

    test "test complex policy with nested resources", ~M{customer, minor, store, inventory} do
      # invalid time
      assert {:error, %Ash.Error.Forbidden{path: []}} =
               Ashex.run_update(store, :purchase,
                 actor: customer,
                 params: %{time: ~T[11:00:00], inventory: %{id: inventory.id, count: 1}}
               )

      # invalid count
      assert {:error, %Ash.Error.Forbidden{path: [:inventory, 0]}} =
               Ashex.run_update(store, :purchase,
                 actor: customer,
                 params: %{time: ~T[16:00:00], inventory: %{id: inventory.id, count: 100}}
               )

      # invalid age
      assert {:error, %Ash.Error.Forbidden{path: [:inventory, 0, :product_id, 0]}} =
               Ashex.run_update(store, :purchase,
                 actor: minor,
                 params: %{time: ~T[16:00:00], inventory: %{id: inventory.id, count: 1}}
               )

      # valid purchase
      assert Ashex.run_update!(store, :purchase,
               actor: customer,
               params: %{time: ~T[16:00:00], inventory: %{id: inventory.id, count: 1}}
             )
    end
  end
end
