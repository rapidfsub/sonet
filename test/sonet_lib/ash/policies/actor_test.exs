defmodule SonetLib.Ash.Policies.ActorTest do
  use SonetLib.DataCase

  defmodule Object do
    use Ash.Resource,
      domain: SonetLib.TestDomain,
      authorizers: [Ash.Policy.Authorizer]

    attributes do
      uuid_v7_primary_key :id
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
      read :get_current_object, get?: true
    end

    policies do
      bypass action(:read) do
        authorize_if always()
      end

      policy action(:get_current_object) do
        authorize_if expr(^actor(:id) == id)
      end
    end
  end

  setup do
    data =
      for _ <- 1..5 do
        %{}
      end

    [object | _] = objects = Ashex.seed!(Object, data)
    ~M{objects, object}
  end

  test "filter by actor", ~M{objects, object} do
    id = object.id
    assert Ashex.set_data_and_read!(Object, :read, objects) |> length == 5

    assert ~M{^id} =
             Ashex.set_data_and_read_one!(Object, :get_current_object, objects, actor: object)
  end
end
