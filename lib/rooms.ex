defmodule Rooms do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def update_users(room_name, pid) do
    Agent.update(__MODULE__, &add_users(&1, room_name, pid))
  end

  def get_users(room_name) do
    Agent.get(__MODULE__, fn all -> all |> get_pids(room_name) end)
  end

  defp add_users(state, room_name, pid) do
    state
    |> Map.update(room_name, [pid], fn pids -> [pid | pids] end)
  end

  defp get_pids(state, room_name) do
    state
    |> Map.get(room_name, [])
  end
end
