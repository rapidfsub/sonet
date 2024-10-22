defmodule SonetLib.SevenEleven.Inventory do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
    table "inventory"
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept :*
      argument :store_id, :string, allow_nil?: false
      argument :product_id, :string, allow_nil?: false
      change manage_relationship(:store_id, :store, type: :append, value_is_key: :id)
      change manage_relationship(:product_id, :product, type: :append, value_is_key: :id)
    end

    update :purchase do
      primary? true
      require_atomic? false
      argument :product_id, :string, public?: false
      argument :count, :integer, allow_nil?: false
      change atomic_update(:count, expr(count - ^arg(:count)))

      change fn changeset, _ctx ->
        Changeset.get_attribute(changeset, :product_id)
        ~> Changeset.set_argument(changeset, :product_id)
      end

      change manage_relationship(:product_id, :product,
               on_lookup: :error,
               on_match: {:update, :purchase},
               value_is_key: :id
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
      forbid_unless expr(count > 0)
      authorize_if expr(^arg(:count) <= count)
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :count, :integer, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :store, SevenEleven.Store do
      allow_nil? false
      public? true
      attribute_writable? false
    end

    belongs_to :product, SevenEleven.Product do
      allow_nil? false
      public? true
      attribute_writable? false
    end
  end
end
