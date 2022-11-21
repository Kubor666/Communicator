defmodule Communicator.Server_to_Client do
  def handle_receive(client, room_name) do
    client

    case :gen_tcp.recv(client, 0, 50) do
      {:ok, message} ->
        Communicator.Server.send_message(message, room_name)
      {:error, _} -> nil
    end
  end
end
