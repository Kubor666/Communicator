defmodule Communicator.Join_to_Server do

  def join_to_server_stage_1(client) do
    select_option(client)
  end

  defp join_to_server_stage_2(client) do
    name = read_line(client)
    Rooms_List.update_rooms(name)
    |>IO.inspect()
    :gen_tcp.send(client, "Succesfully joined to server #{name}")

    name
  end

  defp select_option(client) do
    :gen_tcp.send(client, "Press 1 if you want to see existing rooms, press 2 if you want to create a new one")

    option = read_line(client)
    cond do
      option == "1\n" ->
         rooms = Rooms_List.get_rooms()
         :gen_tcp.send(client, rooms)
         :gen_tcp.send(client, "Please tell me what server you want to join: ")
         join_to_server_stage_2(client)
      true -> select_option(client)
    end
  end

  defp read_line(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)

    data
  end
end
