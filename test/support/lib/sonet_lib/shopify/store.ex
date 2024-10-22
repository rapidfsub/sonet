defmodule SonetLib.Shopify.Store do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: Shopify,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "store"
    repo TestRepo
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create do
      primary? true
      accept :*
      change relate_actor(:user)
    end

    read :read_owned
  end

  policies do
    policy_group action_type(:read) do
      policy action(:read) do
        authorize_if always()
      end

      policy action(:read_owned) do
        authorize_if expr(^actor(:id) == user_id)
      end
    end

    policy action(:create) do
      access_type :strict
      authorize_if actor_present()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :handle, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :user, TestIdentity.User, allow_nil?: false
  end

  identities do
    identity :unique_handle, [:handle]
  end
end
