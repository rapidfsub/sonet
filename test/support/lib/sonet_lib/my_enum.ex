defmodule SonetLib.MyEnum do
  @moduledoc """
  Module for testing SonetLib.Delegate
  """
  use SonetLib.Delegate, [{Enum, [max: 3]}]
end
