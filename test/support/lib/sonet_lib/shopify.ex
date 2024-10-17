defmodule SonetLib.Shopify do
  use Ash.Domain

  resources do
    resource SonetLib.Shopify.Store
  end
end
