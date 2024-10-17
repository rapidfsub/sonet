defmodule SonetLib.TestPrelude do
  defmacro __using__(_opts) do
    quote do
      use SonetLib.Prelude
      alias SonetLib.Shopify
      alias SonetLib.TestIdentity
    end
  end
end
