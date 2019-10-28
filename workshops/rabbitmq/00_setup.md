# Prerequisite

1. Install rabbitmq

  https://www.rabbitmq.com/download.html

2. Visit http://localhost:15672/#/

  - create virtual host
  - create user
  - create exchange
  - create queue
  - publish message


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

#### Connect to rabbitmq

```elixir
{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
```
#### Create queue

```elixir
AMQP.Queue.declare(channel, "hello")
```

#### Send message

```elixir
AMQP.Basic.publish(channel, "", "hello", "Hello World!")
```

#### Close connection

```elixir
AMQP.Connection.close(connection)
```

#### Receive message

```elixir
defmodule Receive do
  def wait_for_messages do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts " [x] Received #{payload}"
        wait_for_messages()
    end
  end
end

{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)
AMQP.Queue.declare(channel, "hello")
AMQP.Basic.consume(channel, "hello", nil, no_ack: true)
IO.puts " [*] Waiting for messages. To exit press CTRL+C, CTRL+C"

Receive.wait_for_messages()
```