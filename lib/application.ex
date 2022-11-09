defmodule Application do

  def start(_type, _args) do
    children = [
      {Task, fn -> Communicator.accept(4040) end}
    ]

    opts = [strategy: :one_for_one, anme: Communicator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
