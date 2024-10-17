defmodule SonetLib.Ashex do
  use SonetLib.Delegate, [
    {Ash.Seed,
     [
       seed!: 1,
       seed!: 3
     ]}
  ]
end
