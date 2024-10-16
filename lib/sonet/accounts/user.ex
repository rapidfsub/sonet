defmodule Sonet.Accounts.User do
  use Ash.Resource,
    otp_app: :sonet,
    domain: Sonet.Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [
      AshAuthentication,
      AshJsonApi.Resource
    ],
    data_layer: AshPostgres.DataLayer,
    fragments: [
      Sonet.Accounts.User.Actions
    ]

  json_api do
    type "user"
  end

  authentication do
    tokens do
      enabled? true
      token_resource Sonet.Accounts.Token
      signing_secret Sonet.Secrets
    end

    strategies do
      password :password do
        identity_field :email

        resettable do
          sender Sonet.Accounts.User.Senders.SendPasswordResetEmail
        end
      end
    end
  end

  postgres do
    table "users"
    repo Sonet.Repo
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      forbid_if always()
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string do
      allow_nil? false
      sensitive? true
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
