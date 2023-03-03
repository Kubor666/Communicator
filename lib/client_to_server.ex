defmodule Communicator.Client_to_Server do
  def handle_send(client) do
    receive do
      {:send_message, message} -> :gen_tcp.send(client, message)
      other -> IO.inspect("Unexpected message: #{inspect(other)}")
    after
      50 -> nil
    end
  end
end
