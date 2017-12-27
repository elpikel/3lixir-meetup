# Migrations

Migrations are used to modify your database schema over time.

```elixir
  defmodule Repo.Migrations.AddPostTable do
    use Ecto.Migration

    def up do
      create table(:posts) do
        add :title, :string
        add :body, :string

        timestamps() # created_at updated_at
      end
    end

    def down do
      drop table(:posts)
    end
  end
```

Note migrations have an up/0 and down/0 instructions, where up/0 is used to update your database and down/0 rolls back the prompted changes.

Migrations can also be automatically reversible by implementing change/0 instead of up/0 and down/0.

```elixir
defmodule Repo.Migrations.AddPostTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string

      timestamps()
    end
  end
end
```

Not all commands are reversible though. Trying to rollback a non-reversible command will raise an Ecto.MigrationError.

Migrations support specifying a table prefix or index prefix which will target either a schema if using Postgres, or a different database if using MySQL. If no prefix is provided, the default schema or database is used.

For both MySQL and Postgres with a prefixed table, you must use the same prefix for the index field to ensure you index the prefix qualified table.

```elixir
defmodule Repo.Migrations.AddPostTable do
  use Ecto.Migration

  def up do
    create table(:posts, prefix: "blog") do
      add :title, :string
      add :body, :string

      timestamps() # created_at updated_at
    end
  end
end
```

By default, Ecto runs all migrations inside a transaction. That’s not always ideal: for example, PostgreSQL allows to create/drop indexes concurrently but only outside of any transaction (see the PostgreSQL docs).

Migrations can be forced to run outside a transaction by setting the @disable_ddl_transaction module attribute to true

You can configure primarykey, migration source and timestams

```elixir
config :ecto_exercises, Repo, migration_source: "my_migrations"
config :ecto_exercises, Repo, migration_primary_key: [id: :uuid, type: :binary_id]
config :ecto_exercises, Repo, migration_timestamps: [type: :utc_datetime]
```


# TODO

-add column to table
-remove column
-rename column
-change column type
-add default value as fragment
-add constraint on column
-create index
-execute sql
-add reference to other table
