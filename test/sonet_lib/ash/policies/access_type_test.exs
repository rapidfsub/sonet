defmodule SonetLib.Ash.Policies.AccessTypeTest do
  use SonetLib.DataCase

  defmodule Object do
    use Ash.Resource,
      domain: TestDomain,
      authorizers: [Ash.Policy.Authorizer]

    attributes do
      uuid_v7_primary_key :id
    end

    actions do
      defaults [:read, :destroy, create: :*, update: :*]
      create :filtered_create
      read :filtered_read
      create :forbidden_create
      read :forbidden_read
    end

    policies do
      policy always() do
        for name <- [:filtered_create, :filtered_read] do
          forbid_if action(name)
        end

        authorize_if always()
      end

      policy always() do
        access_type :strict

        for name <- [:forbidden_create, :forbidden_read] do
          forbid_if action(name)
        end

        authorize_if always()
      end

      policy always() do
        authorize_if always()
      end
    end
  end

  describe "create action" do
    test "pass if authorized" do
      assert Ashex.run_create!(Object, :create)
    end

    test "raise error if filtered" do
      assert {:error, %Ash.Error.Forbidden{}} =
               Ashex.run_create(Object, :filtered_create)
    end

    test "raise error if forbidden" do
      assert {:error, %Ash.Error.Forbidden{}} =
               Ashex.run_create(Object, :forbidden_create)
    end
  end

  describe "read action" do
    setup do
      data =
        for _ <- 1..10 do
          %Object{}
        end
        |> Ashex.seed!()

      %{data: data}
    end

    test "pass if authorized", %{data: data} do
      assert [_ | _] = Ashex.set_data_and_read!(Object, :read, data)
    end

    test "remove unauthorized records if filtered", %{data: data} do
      assert [] = Ashex.set_data_and_read!(Object, :filtered_read, data)
    end

    test "raise error if forbidden", %{data: data} do
      assert {:error, %Ash.Error.Forbidden{}} =
               Ashex.set_data_and_read(Object, :forbidden_read, data)
    end
  end
end
