defmodule SonetLib.SevenEleven.Customer do
  use SonetLib.TestPrelude

  use Ash.Resource,
    domain: SevenEleven,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    repo TestRepo
    schema "seven_eleven"
    table "customer"
  end

  actions do
    defaults [:read, create: :*]
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :age, :integer, allow_nil?: false, public?: true
  end

  relationships do
    has_many :transactions, SevenEleven.Transaction, destination_attribute: :customer_id
  end
end
