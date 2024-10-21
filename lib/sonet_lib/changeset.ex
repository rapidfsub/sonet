defmodule SonetLib.Changeset do
  use SonetLib.Prelude

  use Delegate, [
    {Ash.Changeset,
     [
       change_attribute: 3,
       force_change_attribute: 3,
       for_create: 4,
       for_update: 4,
       get_argument: 2,
       get_attribute: 2,
       set_argument: 3
     ]}
  ]
end
