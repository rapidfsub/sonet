defmodule SonetLib.Ash.Attributes.CommonTest do
  use SonetLib.DataCase

  test "return invalid error if value is nil with option allow_nil? false" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain

      attributes do
        uuid_v7_primary_key :id
        attribute :name, :string, allow_nil?: false
      end

      actions do
        defaults [:read, :destroy, create: :*, update: :*]
      end
    end

    assert {:error, %Ash.Error.Invalid{}} = Ashex.run_create(Object1, :create)
  end
end
