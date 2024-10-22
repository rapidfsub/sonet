defmodule SonetLib.SevenEleven.Store do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
    table "store"
  end

  actions do
    defaults [:read, create: :*]

    update :purchase do
      primary? true
      require_atomic? false
      argument :time, :time, allow_nil?: false
      argument :inventory, :map, allow_nil?: false

      change manage_relationship(:inventory, :inventories,
               on_lookup: :error,
               on_match: {:update, :purchase}
             )
    end
  end

  policies do
    policy action(:read) do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if always()
    end

    policy action(:purchase) do
      forbid_unless expr(open_time < ^arg(:time))
      authorize_if expr(^arg(:time) < close_time)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :open_time, :time, allow_nil?: false, public?: true
    attribute :close_time, :time, allow_nil?: false, public?: true
  end

  relationships do
    has_many :inventories, SevenEleven.Inventory, destination_attribute: :store_id
    has_many :transactions, SevenEleven.Transaction, destination_attribute: :store_id
  end
end
