defmodule Client do

  def connect(username, server) do
    spawn (Client, :init, [username, server])
  end

  def init(username, server) do
    send server, {self, :connect, username}
  end

  def loop(username, server) do
    receive do

    end
  end

end
