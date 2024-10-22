defmodule SonetLib.Fake do
  use SonetLib.Prelude

  use Delegate, [
    {Faker.Internet,
     [
       email: 0
     ]},
    {Faker.Lorem,
     [
       paragraph: 1,
       paragraphs: 1,
       sentence: 1,
       word: 0
     ]}
  ]
end
