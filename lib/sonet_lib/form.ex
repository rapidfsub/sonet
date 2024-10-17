defmodule SonetLib.Form do
  use SonetLib.Prelude

  use Delegate, [
    {AshPhoenix.Form,
     [
       for_create: 3,
       for_update: 3,
       get_form: 2,
       params: 2,
       remove_form: 3,
       submit!: 2,
       validate: 3,
       value: 2
     ]},
    {Phoenix.Component,
     [
       to_form: 2
     ]}
  ]
end
