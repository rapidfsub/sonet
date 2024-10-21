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

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end

  changes do
    change fn changeset, _ctx ->
             changeset
             |> Changeset.get_attribute(:title)
             |> Slugex.title_slug()
             ~> Changeset.force_change_attribute(changeset, :slug)
           end,
           where: [present(:title), changing(:title)]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :title, :string, allow_nil?: false, public?: true
    attribute :description, :string, public?: true
    attribute :body, :string, public?: true
    attribute :slug, :ci_string, allow_nil?: false, public?: true, writable?: false
    timestamps()
  end

  identities do
    identity :unique_slug, [:slug]
  end
end
