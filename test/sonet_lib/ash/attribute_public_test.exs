defmodule SonetLib.Ash.AttributePublicTest do
  use SonetLib.DataCase

  test "cannot accept non public attribute using :*" do
    defmodule Article1 do
      use Ash.Resource,
        domain: SonetLib.TestDomain

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false
      end

      actions do
        defaults create: :*
      end
    end

    assert {:error, %{}} = Ashex.run_create(Article1, :create, %{title: Faker.Lorem.sentence()})
  end

  test "accept non public attribute with explicit whitelist" do
    defmodule Article2 do
      use Ash.Resource,
        domain: SonetLib.TestDomain

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false
      end

      actions do
        defaults create: [:title]
      end
    end

    title = Faker.Lorem.sentence()
    assert %{title: ^title} = Ashex.run_create!(Article2, :create, %{title: title})
  end

  test "accept public attribute using :*" do
    defmodule Article3 do
      use Ash.Resource,
        domain: SonetLib.TestDomain

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false, public?: true
      end

      actions do
        defaults create: :*
      end
    end

    title = Faker.Lorem.sentence()
    assert %{title: ^title} = Ashex.run_create!(Article3, :create, %{title: title})
  end
end
