defmodule SonetLib.Ash.Actions.ArgumentTest do
  use SonetLib.DataCase

  defmodule Article do
    use Ash.Resource,
      domain: SonetLib.TestDomain

    attributes do
      uuid_v7_primary_key :id
      attribute :title, :string
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]

      create :create_pub do
        argument :has_title, :boolean, default: false
        change set_attribute(:title, "Title"), where: argument_equals(:has_title, true)
      end

      create :create_priv do
        argument :has_title, :boolean, default: false, public?: false
        change set_attribute(:title, "Title"), where: argument_equals(:has_title, true)
      end
    end
  end

  test "can set public argument" do
    assert %{title: "Title"} = Ashex.run_create!(Article, :create_pub, params: %{has_title: true})
  end

  test "cannot set private argument" do
    assert %{title: nil} = Ashex.run_create!(Article, :create_priv, params: %{has_title: true})
  end
end
