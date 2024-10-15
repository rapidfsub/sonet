defmodule Sonet.Repo do
  use Ecto.Repo,
    otp_app: :sonet,
    adapter: Ecto.Adapters.Postgres
end
