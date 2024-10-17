defmodule SonetLib.TestIdentity.User do
  use Ash.Resource,
    domain: SonetLib.TestIdentity,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo SonetLib.TestRepo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_primary_key :id
  end
end
