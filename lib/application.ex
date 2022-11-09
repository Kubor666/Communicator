defmodule Communicator_Application do

  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "4040")
    children = [
      {Task, fn -> Communicator.accept(port) end}
    ]

    opts = [strategy: :one_for_one, name: Communicator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
