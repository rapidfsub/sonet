defmodule SonetWeb.Prelude do
  defmacro __using__(_opts) do
    quote do
      use Sonet.Prelude
    end
  end
end
