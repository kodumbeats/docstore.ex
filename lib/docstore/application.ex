defmodule Docstore.Application do
  require Docstore.Database
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Docstore.Worker.start_link(arg)
      # {Docstore.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: Docstore.Router, options: [port: 4000]},
    ]

    Docstore.Database.start

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Docstore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
