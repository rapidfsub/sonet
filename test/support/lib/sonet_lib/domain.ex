defmodule SonetLib.Domain do
  use Ash.Domain

  resources do
    allow_unregistered? true
  end
end
