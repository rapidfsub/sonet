defmodule SonetLib.SevenEleven.Inventory do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
    schema "seven_eleven"
    table "inventory"
  end

  actions do
    defaults [:read, create: :*, update: :*]
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy [action_type(:create), action_type(:update)] do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :count, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :store, SevenEleven.Store, allow_nil?: false, public?: true, writable?: false
    belongs_to :product, SevenEleven.Product, allow_nil?: false, public?: true, writable?: false
  end
end
