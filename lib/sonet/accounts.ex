defmodule Sonet.Accounts do
  use Ash.Domain

  resources do
    resource Sonet.Accounts.Token
    resource Sonet.Accounts.User
  end
end
