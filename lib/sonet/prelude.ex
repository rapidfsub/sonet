defmodule Sonet.Prelude do
  defmacro __using__(_opts) do
    quote do
      use SonetLib.Prelude
      alias Sonet.Accounts
    end
  end
end
