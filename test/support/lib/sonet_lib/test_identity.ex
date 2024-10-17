defmodule SonetLib.TestIdentity do
  use Ash.Domain

  resources do
    resource SonetLib.TestIdentity.User
  end
end
