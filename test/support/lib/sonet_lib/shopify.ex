defmodule SonetLib.Shopify do
  use SonetLib.TestPrelude
  use Ash.Domain

  resources do
    resource Shopify.Store
  end
end
