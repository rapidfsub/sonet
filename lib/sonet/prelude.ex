defmodule Sonet.Prelude do
  defmacro __using__(_opts) do
    quote do
      use SonetLib.Prelude
    end
  end
end
