defmodule Blogger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BloggerWeb.Telemetry,
      Blogger.Repo,
      {DNSCluster, query: Application.get_env(:blogger, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Blogger.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Blogger.Finch},
      # Start a worker by calling: Blogger.Worker.start_link(arg)
      # {Blogger.Worker, arg},
      # Start to serve requests, typically the last entry
      BloggerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blogger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BloggerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
