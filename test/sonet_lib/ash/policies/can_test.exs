defmodule SonetLib.Ash.Policies.CanTest do
  use SonetLib.DataCase

  defmodule Object do
    use Ash.Resource,
      domain: TestDomain,
      authorizers: [Ash.Policy.Authorizer]

    attributes do
      uuid_v7_primary_key :id
      attribute :name, :string, allow_nil?: false, public?: true
      attribute :bio, :string, public?: true
    end

    actions do
      defaults [:read]

      create :create do
        primary? true
        accept :*
        validate present(:bio)
      end
    end

    policies do
      policy always() do
        authorize_if expr(^actor(:is_admin))
      end
    end
  end

  describe "admin" do
    setup do
      %{admin: %{is_admin: true}}
    end

    test "test can function", ~M{admin} do
      assert {:ok, true} = Ashex.can({Object, :create}, admin)

      assert {:ok, true} = Ashex.can({Object, :create, %{name: nil}}, admin)
      assert {:ok, true} = Ashex.can({Object, :create, %{name: "name"}}, admin)

      assert {:ok, true} = Changeset.for_create(Object, :create) |> Ashex.can(admin)

      assert {:ok, true} =
               Changeset.for_create(Object, :create, %{name: nil})
               |> Ashex.can(admin)

      assert {:ok, true} =
               Changeset.for_create(Object, :create, %{name: "name"})
               |> Ashex.can(admin)
    end

    test "test can? function", ~M{admin} do
      assert Ashex.can?({Object, :create}, admin) == true

      assert Ashex.can?({Object, :create, %{name: nil}}, admin) == true
      assert Ashex.can?({Object, :create, %{name: "name"}}, admin) == true
      assert Ashex.can?({Object, :create, %{name: "name", bio: nil}}, admin) == true
      assert Ashex.can?({Object, :create, %{name: "name", bio: "bio"}}, admin) == true

      assert Changeset.for_create(Object, :create) |> Ashex.can?(admin) == true
      assert Changeset.for_create(Object, :create, %{name: nil}) |> Ashex.can?(admin) == true
      assert Changeset.for_create(Object, :create, %{name: "name"}) |> Ashex.can?(admin) == true

      assert Changeset.for_create(Object, :create, %{name: "name", bio: nil})
             |> Ashex.can?(admin) == true

      assert Changeset.for_create(Object, :create, %{name: "name", bio: "bio"})
             |> Ashex.can?(admin) == true
    end
  end
end
