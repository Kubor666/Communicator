defmodule Communicator.Server do
  def serve(client) do
    room_name = join_to_server(client)

    Rooms.update_users(room_name, self())

    loop(client, room_name)
  end

  defp loop(client, room_name) do
    handle_receive(client, room_name)
    handle_send(client)

    loop(client, room_name)
  end

  def join_to_server(client) do
    :gen_tcp.send(client, "Please tell me what server you want to join: ")

    name = read_line(client)

    :gen_tcp.send(client, "Succesfully joined to server #{name}")

    name
  end

  def handle_receive(client, room_name) do
    client

    case :gen_tcp.recv(client, 0, 50) do
      {:ok, message} ->
        send_message(message, room_name)
      {:error, _} -> nil
    end
  end

  def handle_send(client) do
    receive do
      {:send_message, message} -> :gen_tcp.send(client, message)
      other -> IO.inspect("Unexpected message: #{inspect(other)}")
    after
      50 -> nil
    end
  end

  defp read_line(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)

    data
  end

  defp write_line(line, client) do
    :gen_tcp.send(client, line)
  end

  defp send_message(message, room_name) do
    room_name
    |> Rooms.get_users()
    |> List.delete(self())
    |> Enum.each(fn pid ->
      Process.send(pid, {:send_message, message}, [])
    end)
  end
end
