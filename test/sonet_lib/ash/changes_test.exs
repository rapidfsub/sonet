defmodule SonetLib.Ash.ChangesTest do
  use SonetLib.Case

  test "local changes precede global changes" do
    defmodule Article do
      use Ash.Resource,
        domain: SonetLib.Domain

      attributes do
        uuid_primary_key :id
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

    assert_value Article
                 |> Changeset.for_create(:create)
                 |> Ash.create!()
                 |> Map.take([:title]) == %{title: "Global"}
  end
end
