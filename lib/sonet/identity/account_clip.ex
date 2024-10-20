defmodule Sonet.Identity.AccountClip do
  use Sonet.Prelude

  use Ash.Resource,
    otp_app: :sonet,
    domain: Identity,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "account_clip"
    repo Repo
  end

  actions do
    defaults [:destroy, update: :*]

    create :upsert do
      primary? true
      accept :*
      upsert? true
      upsert_identity :unique_owner_target
      change relate_actor(:owner)
    end

    read :list_actives do
      primary? true
      filter expr(is_active)
    end
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :is_active, :boolean, allow_nil?: false, public?: true
    timestamps()
  end

  relationships do
    belongs_to :owner, Identity.Account, allow_nil?: false, public?: true
    belongs_to :target, Identity.Account, allow_nil?: false, public?: true
  end

  identities do
    identity :unique_owner_target, [:owner_id, :target_id]
  end
end
