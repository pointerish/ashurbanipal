defmodule Ashurbanipal.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Ashurbanipal.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.Ashurbanipal
      ),
      Ashurbanipal.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ashurbanipal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def dispatch do
    [
      {:_,
        [
          {"/ws/[...]", Ashurbanipal.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {Ashurbanipal.Router, []}}
        ]
      }
    ]
  end
end
