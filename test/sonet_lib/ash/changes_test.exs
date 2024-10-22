defmodule SonetLib.Ash.ChangesTest do
  use SonetLib.DataCase

  test "local changes precede global changes" do
    defmodule Object do
      use Ash.Resource,
        domain: SonetLib.TestDomain

      attributes do
        uuid_v7_primary_key :id
        attribute :name, :string, allow_nil?: false
      end

      changes do
        change set_attribute(:name, "Global")
      end

      actions do
        create :create do
          change set_attribute(:name, "Local")
        end
      end
    end

    assert_value Ashex.run_create!(Object, :create)
                 |> Map.take([:name]) == %{name: "Global"}
  end
end
