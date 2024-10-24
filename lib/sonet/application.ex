defmodule Sonet.Application do
  use Sonet.Prelude

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SonetWeb.Telemetry,
      Repo,
      {DNSCluster, query: Application.get_env(:sonet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sonet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sonet.Finch},
      # Start a worker by calling: Sonet.Worker.start_link(arg)
      # {Sonet.Worker, arg},
      # Start to serve requests, typically the last entry
      SonetWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :sonet]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sonet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SonetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
