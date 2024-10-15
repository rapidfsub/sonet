defmodule Sonet.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Sonet.Accounts.User, _opts) do
    Application.fetch_env(:sonet, :token_signing_secret)
  end
end
