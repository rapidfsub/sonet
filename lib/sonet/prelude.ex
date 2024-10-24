defmodule Sonet.Prelude do
  defmacro __using__(_opts) do
    quote do
      use SonetLib.Prelude

      alias Sonet.Forum
      alias Sonet.Identity
      alias Sonet.Repo
    end
  end
end
