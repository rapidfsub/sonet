defmodule SonetLib.Changeset do
  use SonetLib.Delegate, [
    {Ash.Changeset,
     [
       for_create: 4
     ]}
  ]
end
