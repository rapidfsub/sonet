defmodule SonetLib.Fake do
  use SonetLib.Prelude

  use Delegate, [
    {Faker.Internet,
     [
       email: 0
     ]}
  ]
end
