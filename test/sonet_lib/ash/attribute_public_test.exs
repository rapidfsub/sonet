defmodule SonetLib.Ash.AttributePublicTest do
  use Sonet.DataCase

  test "cannot accept non public attribute using :*" do
    defmodule Article1 do
      use Ash.Resource,
        domain: SonetLib.Domain

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false
      end

      actions do
        defaults create: :*
      end
    end

    assert {:error, %{}} =
             Article1
             |> Ash.Changeset.for_create(:create, %{title: Faker.Lorem.sentence()})
             |> Ash.create()
  end

  test "accept non public attribute with explicit whitelist" do
    defmodule Article2 do
      use Ash.Resource,
        domain: SonetLib.Domain

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false
      end

      actions do
        defaults create: [:title]
      end
    end

    title = Faker.Lorem.sentence()

    assert %{title: ^title} =
             Article2
             |> Ash.Changeset.for_create(:create, %{title: title})
             |> Ash.create!()
  end

  test "accept public attribute using :*" do
    defmodule Article3 do
      use Ash.Resource,
        domain: SonetLib.Domain

      attributes do
        uuid_primary_key :id
        attribute :title, :string, allow_nil?: false, public?: true
      end

      actions do
        defaults create: :*
      end
    end

    title = Faker.Lorem.sentence()

    assert %{title: ^title} =
             Article3
             |> Ash.Changeset.for_create(:create, %{title: title})
             |> Ash.create!()
  end
end
