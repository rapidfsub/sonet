defmodule Sonet.Accounts.User do
  use Sonet.Prelude

  use Ash.Resource,
    otp_app: :sonet,
    domain: Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [
      AshAuthentication,
      AshJsonApi.Resource
    ],
    data_layer: AshPostgres.DataLayer,
    fragments: [
      Accounts.User.Actions,
      Accounts.User.Read
    ]

  json_api do
    type "user"
  end

  authentication do
    tokens do
      enabled? true
      token_resource Accounts.Token
      signing_secret Sonet.Secrets
    end

    strategies do
      password :password do
        identity_field :email

        resettable do
          sender Accounts.User.Senders.SendPasswordResetEmail
        end
      end
    end
  end

  postgres do
    table "user"
    repo Repo
  end

  policies do
    bypass do
      authorize_if action(:register_with_password)
      authorize_if action(:sign_in_with_password)
    end

    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      access_type :strict
      authorize_if action(:get_current_user)
    end

    policy action(:get_current_user) do
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

  identities do
    identity :unique_email, [:email]
  end
end
