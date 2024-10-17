defmodule SonetLib.Identity.User do
  use Ash.Resource,
    domain: SonetLib.Identity,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
    repo SonetLib.TestRepo
  end

  attributes do
    uuid_primary_key :id
  end
end
