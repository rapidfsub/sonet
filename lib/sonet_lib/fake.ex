defmodule SonetLib.Fake do
  use SonetLib.Delegate, [
    {Faker.Internet,
     [
       email: 0
     ]}
  ]
end
