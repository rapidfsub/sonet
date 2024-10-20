defmodule Sonet.Identity.Account do
  use Sonet.Prelude

  use Ash.Resource,
    otp_app: :sonet,
    domain: Identity,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [
      AshAuthentication,
      AshJsonApi.Resource
    ],
    data_layer: AshPostgres.DataLayer,
    fragments: [
      Identity.Account.Actions,
      Identity.Account.Read
    ]

  json_api do
    type "account"
  end

  authentication do
    tokens do
      enabled? true
      token_resource Identity.Token
      signing_secret Sonet.Secrets
    end

    strategies do
      password :password do
        identity_field :email

        resettable do
          sender Identity.Account.Senders.SendPasswordResetEmail
        end
      end
    end
  end

  postgres do
    table "account"
    repo Repo
  end

  policies do
    bypass do
      authorize_if action(:register_with_password)
      authorize_if action(:sign_in_with_password)
      authorize_if action(:read)
    end

    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      access_type :strict
      authorize_if action(:get_current_account)
      authorize_if action(:update_current_account)
      authorize_if action(:follow)
    end

    policy action(:get_current_account) do
      access_type :strict
      authorize_if actor_present()
    end

    policy action(:update_current_account) do
      access_type :strict
      authorize_if actor_present()
    end

    policy action(:follow) do
      access_type :strict
      authorize_if actor_present()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
    attribute :username, :string, allow_nil?: false, public?: true
    attribute :bio, :string, public?: true
    timestamps()
  end

  relationships do
    has_many :follower_clips, Identity.AccountClip, destination_attribute: :target_id

    many_to_many :followers, Identity.Account do
      through Identity.AccountClip
      source_attribute_on_join_resource :target_id
      destination_attribute_on_join_resource :owner_id
    end

    many_to_many :followees, Identity.Account do
      through Identity.AccountClip
      source_attribute_on_join_resource :owner_id
      destination_attribute_on_join_resource :target_id
    end
  end

  calculations do
    calculate :is_following, :boolean, expr(exists(followers, id == ^actor(:id)))
  end

  identities do
    identity :unique_email, [:email]
    identity :unique_username, [:username]
  end
end
