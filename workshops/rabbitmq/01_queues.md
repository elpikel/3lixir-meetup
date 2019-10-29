# Topics

1. Queues
2. Message acknowledgment
3. Message durability
4. Round-robin dispatching

# Create sample app

1. `mix new sample_app`
2. edit `mix.exs`

 - add amqp to applications
```elixir
def application() do
  [applications: [:logger, :amqp]]
end
```
 - and to deps
```elixir
def deps() do
  [{:amqp, "~> 1.0"}]
end
```
3. cd sample_app and run `mix deps.get`

#### Create task

```elixir
{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

AMQP.Queue.declare(channel, "task_queue", durable: true)

message =
  case System.argv do
    []    -> "Hello World!"
    words -> Enum.join(words, " ")
  end

AMQP.Basic.publish(channel, "", "task_queue", message, persistent: true)
IO.puts " [x] Sent '#{message}'"

AMQP.Connection.close(connection)
```

#### Create worker

```elixir
defmodule Worker do
  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.puts " [x] Received #{payload}"
        payload
        |> to_char_list
        |> Enum.count(fn x -> x == ?. end)
        |> Kernel.*(1000)
        |> :timer.sleep
        IO.puts " [x] Done."
        AMQP.Basic.ack(channel, meta.delivery_tag)

        wait_for_messages(channel)
    end
  end
end

{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

AMQP.Queue.declare(channel, "task_queue", durable: true)
AMQP.Basic.qos(channel, prefetch_count: 1)

AMQP.Basic.consume(channel, "task_queue")
IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

Worker.wait_for_messages(channel)
```

#### Dispatching messages

1. Run two workers `mix run worker.exs`
2. Dispatch several messages `mix run new_task.exs message1`

