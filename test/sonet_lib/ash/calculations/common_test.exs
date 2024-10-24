defmodule SonetLib.Ash.Calculations.CommonTest do
  use SonetLib.DataCase

  test "calculate with argument" do
    defmodule Object1 do
      use Ash.Resource,
        domain: TestDomain

      actions do
        defaults [:read, :destroy, create: :*, update: :*]
      end

      attributes do
        uuid_v7_primary_key :id
        attribute :start_date, :date, allow_nil?: false, public?: true
      end

      calculations do
        calculate :duration, :integer do
          argument :end_date, :date, allow_nil?: false

          calculation fn objects, %{arguments: arguments} ->
            Enum.map(objects, &Date.diff(arguments.end_date, &1.start_date))
          end
        end
      end
    end

    assert obj = Ashex.run_create!(Object1, :create, params: %{start_date: ~D[2000-01-01]})

    assert_value Ashex.load!(obj, duration: [end_date: ~D[2010-01-01]]) |> Map.take([:duration]) ==
                   %{duration: 3653}
  end
end
