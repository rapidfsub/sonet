defmodule Sonet.Factory do
  use Sonet.Prelude
  use Smokestack

  factory Identity.Account do
    attribute :email, &Fake.email/0
    attribute :username, &Fake.username/0
    attribute :bio, &Fake.paragraph/0
    attribute :hashed_password, fn -> Bcrypt.hash_pwd_salt("password") end
  end

  factory Identity.Account, :with_token do
    attribute :email, &Fake.email/0
    attribute :username, &Fake.username/0
    attribute :bio, &Fake.paragraph/0
    attribute :hashed_password, fn -> Bcrypt.hash_pwd_salt("password") end

    after_build(fn account ->
      Ashex.run_read_one!(Identity.Account, :sign_in_with_password,
        params: %{email: account.email, password: "password"}
      )
    end)
  end
end
