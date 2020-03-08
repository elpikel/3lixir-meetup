defmodule Publisher do
  @moduledoc """
  Documentation for `Publisher`.
  """

  @doc """
  Publishes message to hello queu
  """
  def publish do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, "hello")
    AMQP.Basic.publish(channel, "", "hello", "Hello World!")

    IO.puts " [x] Sent 'Hello World!'"

    AMQP.Connection.close(connection)
  end
end
