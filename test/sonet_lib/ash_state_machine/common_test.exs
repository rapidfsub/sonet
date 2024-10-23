defmodule SonetLib.AshStateMachine.CommonTest do
  use SonetLib.DataCase

  defmodule Object do
    use Ash.Resource,
      domain: SonetLib.TestDomain,
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
  end

  test "test transition_state" do
    assert object = Ashex.run_create!(Object, :create)
    assert %{state: :done} = Ashex.run_update!(object, :progress)
  end

  test "create with non initial state" do
    assert Ashex.run_create!(Object, :create)
  end
end
