defmodule SonetLib.TestPrelude do
  defmacro __using__(_opts) do
    quote do
      use SonetLib.Prelude
      alias SonetLib.SevenEleven
      alias SonetLib.TestDomain
      alias SonetLib.TestIdentity
      alias SonetLib.TestRepo
    end
  end
end
