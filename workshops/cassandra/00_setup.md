# Create console app

1. `mix new sample_app`
2. edit `mix.exs` 

 - add xandra to applications
```elixir
def application() do
  [applications: [:logger, :xandra]]
end
```
 - and to deps
```elixir
def deps() do
  [{:xandra, "~> 0.10"}]
end
```
3. cd sample_app and run `mix deps.get`

TODO: 
- how to connect
- how to create keyspace
- how to create table
- how to insert 
- how to query
- how to run cassandra in docker
- describe tableplus
