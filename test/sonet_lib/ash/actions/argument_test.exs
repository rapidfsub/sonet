defmodule SonetLib.Ash.Actions.ArgumentTest do
  use SonetLib.DataCase

  defmodule Object do
    use Ash.Resource,
      domain: SonetLib.TestDomain

    attributes do
      uuid_v7_primary_key :id
      attribute :name, :string
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]

      create :create_pub do
        argument :has_name, :boolean, default: false
        change set_attribute(:name, "Name"), where: argument_equals(:has_name, true)
      end

      create :create_priv do
        argument :has_name, :boolean, default: false, public?: false
        change set_attribute(:name, "Name"), where: argument_equals(:has_name, true)
      end
    end
  end

  test "can set public argument" do
    assert %{name: "Name"} = Ashex.run_create!(Object, :create_pub, params: %{has_name: true})
  end

  test "cannot set private argument" do
    assert %{name: nil} = Ashex.run_create!(Object, :create_priv, params: %{has_name: true})
  end
end
