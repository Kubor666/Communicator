defmodule Communicator.Join_to_Server do

  defp new_room_list do
    room_list = []
  end

  def join_to_server(client) do
    :gen_tcp.send(client, "Please tell me what server you want to join: ")

    name = read_line(client)
    add_room_to_room_list(name, room_list)

    :gen_tcp.send(client, "Succesfully joined to server #{name}")

    name
  end

  defp add_room_to_room_list(name, room_list) do
    room_list = [name | room_list]
  end

  def show_rooms(client, room_list = []) do
    :gen_tcp.send(client, room_list)
    :gen_tcp.send(client, "Please select the room from the list above")

    name = read_line(client)

    :gen_tcp.send(client, "Succesfully joined to server #{name}")
  end

  def select_option(client) do
    :gen_tcp.send(client, "Press 1 if you want to see existing rooms, press 2 if you want to create a new one")

    option = read_line(client)
    cond do
      option == "2" -> Communicator.join_to_server(client)
      option == "1" -> Communciator.show_rooms(client)
      true -> select_option(client)
    end
  end

  defp read_line(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)

    data
  end
end
