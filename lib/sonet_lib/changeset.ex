defmodule SonetLib.Changeset do
  use SonetLib.Prelude

  use Delegate, [
    {Ash.Changeset,
     [
       for_create: 4
     ]}
  ]
end
