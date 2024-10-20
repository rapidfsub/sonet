defmodule SonetLib.Prelude do
  defmacro __using__(_opts) do
    quote do
      alias SonetLib.Ashex
      alias SonetLib.Changeset
      alias SonetLib.Delegate
      alias SonetLib.Enumex
      alias SonetLib.Fake
      alias SonetLib.Form
      alias SonetLib.Observer
      alias SonetLib.Query
    end
  end
end
