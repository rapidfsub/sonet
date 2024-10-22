defmodule SonetLib.SevenEleven.Transaction do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
    table "transaction"
  end

  actions do
    defaults [:read, create: :*]
  end

  policies do
    policy action_type(:read) do
      authorize_if relating_to_actor(:customer)
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :count, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :customer, SevenEleven.Customer, allow_nil?: false, public?: true, writable?: false
    belongs_to :store, SevenEleven.Store, allow_nil?: false, public?: true, writable?: false
    belongs_to :product, SevenEleven.Product, allow_nil?: false, public?: true, writable?: false
  end
end
