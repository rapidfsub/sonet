defmodule Sonet.TestPrelude do
  defmacro __using__(_opts) do
    quote do
      use Sonet.Factory
      use Sonet.Prelude
    end
  end
end
