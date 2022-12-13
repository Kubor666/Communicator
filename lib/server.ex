defmodule Communicator.Server do
  def serve(client) do
    room_name = Communicator.Join_to_Server.join_to_server_stage_1(client)

    Rooms.update_users(room_name, self())

    loop(client, room_name)
  end

  def send_message(message, room_name) do
    room_name
    |> Rooms.get_users()
    |> List.delete(self())
    |> Enum.each(fn pid ->
      Process.send(pid, {:send_message, message}, [])
    end)
  end

  defp loop(client, room_name) do
    Communicator.Client_to_Server.handle_send(client)
    Communicator.Server_to_Client.handle_receive(client, room_name)

    loop(client, room_name)
  end
end
