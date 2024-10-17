defmodule SonetLib.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias SonetLib.Changeset
    end
  end
end
