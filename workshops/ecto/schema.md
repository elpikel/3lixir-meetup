# Schema

An Ecto schema is used to map any data source into an Elixir struct. One of such use cases is to map data coming from a repository, usually a table, into Elixir structs.

```elixir
defmodule User do
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :age, :integer, default: 0
    has_many :posts, Post
  end
end
```

By default, a schema will automatically generate a primary key which is named id and of type :integer. The field macro defines a field in the schema with given name and type. has_many associates many posts with the user schema.


# Exercises

1. Change primary_key to uuid
2. Check all ecto types
3. Define posts, users, comments, categories tables (migrations&schemas)
4. Implement ecto custom type
