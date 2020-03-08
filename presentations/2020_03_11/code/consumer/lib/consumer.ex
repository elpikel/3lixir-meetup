defmodule Consumer do
  @moduledoc """
  Documentation for `Consumer`.
  """

  @doc """
  Consumes messages from hello queue and display them on io
  """
  def consume do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, "hello")
    AMQP.Basic.consume(channel, "hello", nil, no_ack: true)

    IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

    wait_for_messages()
  end

  defp wait_for_messages do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts " [x] Received #{payload}"
        wait_for_messages()
    end
  end
end
