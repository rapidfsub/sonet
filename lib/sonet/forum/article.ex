defmodule Sonet.Forum.Article do
  use Sonet.Prelude

  use Ash.Resource,
    domain: Forum,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshArchival.Resource,
      AshJsonApi.Resource
    ]

  json_api do
    type "article"
  end

  postgres do
    table "article"
    repo Repo
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
end
