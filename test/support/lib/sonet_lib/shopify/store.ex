defmodule SonetLib.Shopify.Store do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: Shopify,
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
    attribute :handle, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :user, TestIdentity.User, allow_nil?: false
  end

  identities do
    identity :unique_handle, [:handle]
  end
end
