defmodule Sonet.Factory do
  use Sonet.Prelude
  use Smokestack

  factory Identity.Account do
    attribute :email, &Fake.email/0
    attribute :username, &Fake.word/0
    attribute :bio, &Fake.paragraph/0
    attribute :hashed_password, fn -> Bcrypt.hash_pwd_salt("password") end
  end
end
