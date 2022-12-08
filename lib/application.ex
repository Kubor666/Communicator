defmodule Communicator_Application do

  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "4040")
    Communicator.Join_to_Server.new_room_list

    children = [
      {Task.Supervisor, name: Communicator.TaskSupervisor},
      {Task, fn -> Communicator.accept(port) end},
      Rooms
    ]

    opts = [strategy: :one_for_one, name: Communicator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
