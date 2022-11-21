defmodule Communicator.Join_to_Server do
  def join_to_server(client) do
    :gen_tcp.send(client, "Please tell me what server you want to join: ")

    name = read_line(client)

    :gen_tcp.send(client, "Succesfully joined to server #{name}")

    name
  end

  defp read_line(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)

    data
  end
end
