defmodule SonetLib.Ash.Type.DecimalTest do
  use SonetLib.DataCase

  defmodule BankAccount do
    use Ash.Resource,
      domain: SonetLib.TestDomain

    attributes do
      uuid_v7_primary_key :id
      attribute :balance, :decimal, allow_nil?: false, public?: true
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
    end
  end

  test "Decimal.equal?/2 handles nil" do
    assert ba = Ashex.run_create!(BankAccount, :create, params: %{balance: 100})
    assert {:error, %{}} = Ashex.run_update(ba, :update, params: %{balance: nil})
  end
end
