defmodule SonetLib.Identity do
  use Ash.Domain

  resources do
    resource SonetLib.Identity.User
  end
end
