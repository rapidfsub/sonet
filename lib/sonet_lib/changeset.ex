defmodule SonetLib.Changeset do
  use SonetLib.Prelude

  use Delegate, [
    {Ash.Changeset,
     [
       for_create: 4,
       for_update: 4,
       get_argument: 2,
       set_argument: 3
     ]}
  ]
end
