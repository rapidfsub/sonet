defmodule SonetLib.SevenEleven.Product do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
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
      forbid_unless actor_present()
      authorize_if expr(not is_adult_only or ^actor(:age) >= 19)
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
  end
end
