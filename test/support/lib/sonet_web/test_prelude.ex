defmodule SonetWeb.TestPrelude do
  defmacro __using__(_opts) do
    quote do
      use Sonet.TestPrelude
    end
  end
end
