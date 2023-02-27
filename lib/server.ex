defmodule Communicator.Server do
  def serve(client) do
    room_name = Communicator.Join_to_Server.join_to_server_stage_1(client)

    {:ok, nickname} = Communicator.Join_to_Server.get_nickname(client)

    Rooms.update_users(room_name, {self(), nickname})

    loop(client, room_name, nickname)
  end

  def send_message(message, room_name, sender_nickname) do
    room_name
    |> Rooms.get_users()
    |> Enum.each(fn {pid, nickname} ->
      if nickname != sender_nickname do
        Process.send(pid, {:send_message, "#{nickname}: #{message}"}, [])
      end
    end)
  end

  defp loop(client, room_name, nickname) do
    Communicator.Client_to_Server.handle_send(client)
    Communicator.Server_to_Client.handle_receive(client, room_name, nickname)

    loop(client, room_name, nickname)
  end
end
