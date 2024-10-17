defmodule SonetLib.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import AssertValue
      use SonetLib.Prelude
    end
  end

  setup _tags do
    :ok
  end
end
