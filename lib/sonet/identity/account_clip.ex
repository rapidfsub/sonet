defmodule Sonet.Identity.AccountClip do
  use Sonet.Prelude

  use Ash.Resource,
    otp_app: :sonet,
    domain: Identity,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshArchival.Resource
    ]

  postgres do
    table "account_clip"
    repo Repo
  end

  actions do
    defaults [:read, :destroy, update: :*]

    create :create_or_unarchive do
      primary? true
      accept :*
      upsert? true
      upsert_identity :unique_owner_target
      change relate_actor(:owner)
    end
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
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
