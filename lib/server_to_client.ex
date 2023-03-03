defmodule Communicator.Server_to_Client do
  def handle_receive(client, room_name, nickname) do
    case :gen_tcp.recv(client, 0, 50) do
      {:ok, message} ->
        if message == "exit\n" do
          Rooms.remove_user(room_name, {self(), nickname})
          Communicator.Server.send_message("Left the chatroom", room_name, nickname)
          :gen_tcp.close(client)
        else
          Communicator.Server.send_message(message, room_name, nickname)
        end

      {:error, _} ->
        nil
    end
  end
end
