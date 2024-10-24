defmodule SonetLib.Ash.Validations.CompareTest do
  use SonetLib.DataCase

  test "skip validation if nil" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain

      actions do
        create :create do
          primary? true
          accept [:percent]

          # run validation only when percent is not nil
          validate compare(:percent, greater_than: 0)

          # raise error when calling Decimal.gt?/2 if percent is nil, even if only_when_valid? is true
          change fn changeset, _ctx ->
                   Changeset.get_attribute(changeset, :percent)
                   |> Decimal.lt?(50)
                   ~> Changeset.change_attribute(changeset, :less_than_half)
                 end,
                 only_when_valid?: true
        end
      end

      attributes do
        uuid_v7_primary_key :id
        attribute :percent, :decimal, public?: true
        attribute :less_than_half, :boolean, public?: true
      end
    end

    assert %{less_than_half: true} = Ashex.run_create!(Object1, :create, params: %{percent: 15})

    assert_raise FunctionClauseError, fn ->
      Ashex.run_create(Object1, :create, params: %{percent: nil})
    end
  end
end
