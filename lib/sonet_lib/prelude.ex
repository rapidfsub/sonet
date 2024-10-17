defmodule SonetLib.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias SonetLib.Ashex
      alias SonetLib.Changeset
      alias SonetLib.Query
    end
  end
end