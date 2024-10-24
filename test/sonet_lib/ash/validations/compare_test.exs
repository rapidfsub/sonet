defmodule SonetLib.Ash.Validations.CompareTest do
  use SonetLib.DataCase

  test "run validation only if not nil" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain

      actions do
        create :create do
          primary? true
          accept [:percent]
          validate compare(:percent, greater_than: 0)
        end
      end

      attributes do
        uuid_v7_primary_key :id
        attribute :percent, :decimal, public?: true
      end
    end

    assert {:error, %Ash.Error.Invalid{}} =
             Ashex.run_create(Object1, :create, params: %{percent: -100})

    assert %{} = Ashex.run_create!(Object1, :create, params: %{percent: nil})
  end
end
