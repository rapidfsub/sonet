defmodule SonetLib.Ash.AttributePublicTest do
  use SonetLib.DataCase

  test "cannot accept non public attribute using :*" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain

      attributes do
        uuid_v7_primary_key :id
        attribute :name, :string, allow_nil?: false
      end

      actions do
        defaults create: :*
      end
    end

    assert {:error, %{}} = Ashex.run_create(Object1, :create, params: %{name: Fake.sentence()})
  end

  test "accept non public attribute with explicit whitelist" do
    defmodule Object2 do
      use Ash.Resource,
        domain: TestDomain

      attributes do
        uuid_v7_primary_key :id
        attribute :name, :string, allow_nil?: false
      end

      actions do
        defaults create: [:name]
      end
    end

    name = Fake.sentence()
    assert %{name: ^name} = Ashex.run_create!(Object2, :create, params: %{name: name})
  end

  test "accept public attribute using :*" do
    defmodule Object3 do
      use Ash.Resource,
        domain: TestDomain

      attributes do
        uuid_v7_primary_key :id
        attribute :name, :string, allow_nil?: false, public?: true
      end

      actions do
        defaults create: :*
      end
    end

    name = Fake.sentence()
    assert %{name: ^name} = Ashex.run_create!(Object3, :create, params: %{name: name})
  end
end
