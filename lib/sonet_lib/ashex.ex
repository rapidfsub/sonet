defmodule SonetLib.Ashex do
  use SonetLib.Prelude

  use Delegate, [
    {Ash,
     [
       create: 3,
       create!: 3,
       read: 2,
       read!: 2,
       load!: 3
     ]},
    {Ash.Seed,
     [
       seed!: 1,
       seed!: 3
     ]}
  ]
end
