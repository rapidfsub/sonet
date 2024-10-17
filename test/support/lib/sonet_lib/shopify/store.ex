defmodule SonetLib.Shopify.Store do
  use Ash.Resource,
    domain: SonetLib.Shopify,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "store"
    repo SonetLib.TestRepo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_primary_key :id
  end

  relationships do
    belongs_to :user, SonetLib.TestIdentity.User
  end
end
