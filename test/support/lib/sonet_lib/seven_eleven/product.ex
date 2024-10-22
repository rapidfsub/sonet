defmodule SonetLib.SevenEleven.Product do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
    schema "seven_eleven"
    table "product"
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept :*
      argument :store_id, :string, allow_nil?: false
      change manage_relationship(:store_id, :store, type: :append, value_is_key: :id)
    end

    update :purchase do
      require_atomic? false
      # argument :transaction, :map, allow_nil?: false, public?: false, default: %{count: 1}
      # change manage_relationship(:transaction, :transactions, type: :create)
    end
  end

  policies do
    policy action(:read) do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if always()
    end

    # policy action(:purchase) do`

    policy action(:purchase) do
      forbid_unless actor_present()
      forbid_unless expr(not is_adult_only or ^actor(:age) >= 19)
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :is_adult_only, :boolean, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :store, SevenEleven.Store do
      allow_nil? false
      public? true
      attribute_writable? false
    end

    has_many :transactions, SevenEleven.Transaction, destination_attribute: :product_id
  end
end
