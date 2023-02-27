defmodule Communicator.Server_to_Client do
  def handle_receive(client, room_name) do
    client

    case :gen_tcp.recv(client, 0, 50) do
      {:ok, message} ->
        if message == "exit\n" do
          Rooms.update_users(room_name, self())
          :gen_tcp.close(client)
        else
          Communicator.Server.send_message(message, room_name)
        end
      {:error, _} -> nil
    end
  end
end
