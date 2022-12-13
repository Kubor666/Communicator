defmodule Rooms_List do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def update_rooms(room_name) do
    Agent.update(__MODULE__, fn list -> [room_name | list] end)
  end

  def get_rooms() do
    Agent.get(__MODULE__, fn list -> list end)
  end

end
