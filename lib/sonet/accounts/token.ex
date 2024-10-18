defmodule Sonet.Accounts.Token do
  use Sonet.Prelude

  use Ash.Resource,
    otp_app: :sonet,
    domain: Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication.TokenResource],
    data_layer: AshPostgres.DataLayer,
    fragments: [
      Accounts.Token.Actions
    ]

  postgres do
    table "tokens"
    repo Repo
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      description "AshAuthentication can interact with the token resource"
      authorize_if always()
    end

    policy always() do
      description "No one aside from AshAuthentication can interact with the tokens resource."
      forbid_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :jti, :string do
      primary_key? true
      public? true
      allow_nil? false
      sensitive? true
    end

    timestamps()
  end
end
