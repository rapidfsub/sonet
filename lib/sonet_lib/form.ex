defmodule SonetLib.Form do
  use SonetLib.Delegate, [
    {AshPhoenix.Form,
     [
       for_create: 3,
       for_update: 3,
       submit!: 2,
       validate: 3
     ]}
  ]
end
