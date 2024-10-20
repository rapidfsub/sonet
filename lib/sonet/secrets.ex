defmodule Sonet.Secrets do
  use Sonet.Prelude
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Identity.Account, _opts) do
    Application.fetch_env(:sonet, :token_signing_secret)
  end
end
