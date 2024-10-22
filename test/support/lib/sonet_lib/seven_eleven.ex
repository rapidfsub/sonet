defmodule SonetLib.SevenEleven do
  use SonetLib.TestPrelude
  use Ash.Domain

  resources do
    resource SevenEleven.Customer
    resource SevenEleven.Inventory
    resource SevenEleven.Product
    resource SevenEleven.Store
    resource SevenEleven.Transaction
  end
end
