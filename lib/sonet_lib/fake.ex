defmodule SonetLib.Fake do
  use SonetLib.Prelude

  use Delegate, [
    {Faker.Internet,
     [
       email: 0
     ]},
    {Faker.Lorem,
     [
       sentence: 1,
       word: 0
     ]}
  ]
end
