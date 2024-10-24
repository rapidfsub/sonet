defmodule SonetLib.Ash.Validations.OnlyWhenValidTest do
  use SonetLib.DataCase

  test "does not check allow_nil? condition" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain

      actions do
        create :create do
          primary? true
          accept :*

          # raise error if x or y is nil, even if only_when_valid? is true
          validate fn changeset, _ctx ->
                     x = Changeset.get_attribute(changeset, :x)
                     y = Changeset.get_attribute(changeset, :y)

                     if x + y > 0 do
                       :ok
                     else
                       {:error, :invalid}
                     end
                   end,
                   only_when_valid?: true
        end
      end

      attributes do
        uuid_v7_primary_key :id
        attribute :x, :integer, allow_nil?: false, public?: true
        attribute :y, :integer, allow_nil?: false, public?: true
      end
    end

    assert Ashex.run_create!(Object1, :create, params: %{x: 1, y: 2})

    assert_raise ArithmeticError, fn ->
      Ashex.run_create(Object1, :create, params: %{x: nil, y: 2})
    end
  end
end
