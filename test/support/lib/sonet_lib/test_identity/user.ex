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
  end

  attributes do
    uuid_primary_key :id
  end

  relationships do
    has_many :stores, SonetLib.Shopify.Store
  end
end
