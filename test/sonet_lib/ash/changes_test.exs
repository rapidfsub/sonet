defmodule SonetLib.Ash.ChangesTest do
  use SonetLib.DataCase

  test "local changes precede global changes" do
    defmodule Article do
      use Ash.Resource,
        domain: SonetLib.TestDomain

      attributes do
        uuid_v7_primary_key :id
        attribute :title, :string, allow_nil?: false
      end

      changes do
        change set_attribute(:title, "Global")
      end

      actions do
        create :create do
          change set_attribute(:title, "Local")
        end
      end
    end

    assert_value Ashex.run_create!(Article, :create)
                 |> Map.take([:title]) == %{title: "Global"}
  end
end
