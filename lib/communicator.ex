defmodule Communicator do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connection on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    # Wait for socket connection
    {:ok, client} = :gen_tcp.accept(socket)

    # Start serving the socket
    {:ok, pid} = Task.Supervisor.start_child(Communicator.TaskSupervisor, fn -> Communicator.Server.serve(client) end)
    IO.inspect(%{client: client, pid: pid})

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end
end
