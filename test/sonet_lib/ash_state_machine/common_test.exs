defmodule SonetLib.AshStateMachine.CommonTest do
  use SonetLib.DataCase

  defmodule Object do
    use Ash.Resource,
      domain: TestDomain,
      authorizers: [Ash.Policy.Authorizer],
      extensions: [AshStateMachine]

    attributes do
      uuid_v7_primary_key :id
    end

    state_machine do
      initial_states [:pending]
      default_initial_state :pending

      transitions do
        transition :progress, from: :pending, to: :done
      end
    end

    actions do
      defaults [:read, create: :*, update: :*]

      update :progress do
        change transition_state(:done)
      end
    end

    policies do
      policy always() do
        authorize_if AshStateMachine.Checks.ValidNextState
      end
    end
  end

  test "test transition_state" do
    assert object = Ashex.run_create!(Object, :create)
    assert %{state: :done} = Ashex.run_update!(object, :progress)
  end

  test "prevent create with non initial state by AshStateMachine.Checks.ValidNextState" do
    assert {:error, %Ash.Error.Forbidden{}} =
             Ashex.run_create(Object, :create, params: %{state: :done})
  end

  test "fail when progress twice" do
    assert object = Ashex.run_create!(Object, :create)
    assert %{state: :done} = object = Ashex.run_update!(object, :progress)
    assert Ashex.can?({object, :progress}, nil) == false
    assert {:error, %Ash.Error.Forbidden{}} = Ashex.run_update(object, :progress, actor: nil)
  end
end
