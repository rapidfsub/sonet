defmodule SonetLib.TestIdentity do
  use SonetLib.TestPrelude
  use Ash.Domain

  resources do
    resource TestIdentity.User
  end
end
