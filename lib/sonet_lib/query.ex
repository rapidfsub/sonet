defmodule SonetLib.Query do
  use SonetLib.Prelude

  use Delegate, [
    {Ash.Query,
     [
       for_read: 4
     ]}
  ]
end
