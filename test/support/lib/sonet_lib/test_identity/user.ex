defmodule SonetLib.TestIdentity.User do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: TestIdentity,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "user"
    repo SonetLib.TestRepo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    create :create_with_stores do
      argument :stores, {:array, :map}
      change manage_relationship(:stores, type: :create)
    end

    update :update_with_stores do
      require_atomic? false
      argument :stores, {:array, :map}
      change manage_relationship(:stores, type: :direct_control)
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
  end

  relationships do
    has_many :stores, Shopify.Store
  end

  identities do
    identity :unique_email, [:email]
  end
end
