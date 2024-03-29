defmodule Communicator.Join_to_Server do
  def join_to_server_stage_1(client) do
    select_option(client)
  end

  defp join_to_server_stage_2(client) do
    name = read_line(client)

    Rooms_List.update_rooms(name)

    :gen_tcp.send(client, "Succesfully joined to chatroom #{name}")
    name
  end

  defp select_option(client) do
    :gen_tcp.send(
      client,
      "Press 1 if you want to see existing rooms, press 2 if you want to create a new one"
    )

    option = read_line(client)

    cond do
      option == "1\n" ->
        rooms = Rooms_List.get_rooms()
        :gen_tcp.send(client, rooms)
        :gen_tcp.send(client, "Please tell me what chatroom you want to join: ")
        join_to_server_stage_2(client)

      option == "2\n" ->
        :gen_tcp.send(client, "What will be the name of your chatroom: ")
        join_to_server_stage_2(client)

      true ->
        select_option(client)
    end
  end

  def get_nickname(client) do
    :gen_tcp.send(client, "Please enter your nickname: ")
    nickname = read_line(client)
    {:ok, String.trim(nickname)}
  end

  defp read_line(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)

    data
  end
end
