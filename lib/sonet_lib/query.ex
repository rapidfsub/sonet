defmodule SonetLib.Query do
  use SonetLib.Delegate, [
    {Ash.Query,
     [
       for_read: 4
     ]}
  ]
end
