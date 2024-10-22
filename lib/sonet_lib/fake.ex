defmodule SonetLib.Fake do
  use SonetLib.Prelude

  use Delegate, [
    {Faker.Airports.En,
     [
       airport_name: [arity: 0, as: :name]
     ]},
    {Faker.Aws.En,
     [
       ec2_action: 0
     ]},
    {Faker.Food.En,
     [
       ingredient: 0
     ]},
    {Faker.Internet,
     [
       email: 0,
       username: [arity: 0, as: :user_name]
     ]},
    {Faker.Lorem,
     [
       paragraph: 1,
       paragraphs: 1,
       sentence: 1,
       word: 0
     ]},
    {Faker.Person.En,
     [
       name: 0
     ]}
  ]
end
