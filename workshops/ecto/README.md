# Create first app

1. Create app : ```mix new <app_name> --sup```
2. Add repo - Ecto.Repo is a wrapper around the database:
```elixir
defmodule Repo do
  use Ecto.Repo, otp_app: :app_name
end
```
3. Add worker (Each repository in Ecto defines a start_link/0 function that needs to be invoked before using the repository. In general, this function is not called directly, but used as part of your application supervision tree.):
```elixir
supervisor(Repo, [])
```
4. Add config :
```elixir
config :app_name, :ecto_repos, [Repo]

config :app_name, Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_exercises",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
```
5. Add dependencies :
```elixir
{:ecto, "~> 2.2"},
{:postgrex, ">= 0.0.0"}
```
6. Run : ```mix ecto.create```
7. Run : ```mix ecto.gen.migration add_post_table```
8. Edit migration :
```elixir
  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string

      timestamps()
    end
  end
```
9. Add schema (Schemas allows developers to define the shape of their data.)
Notice how the storage (repository) and the data are decoupled. This provides two main benefits:

By having structs as data, we guarantee they are light-weight, serializable structures. In many languages, the data is often represented by large, complex objects, with entwined state transactions, which makes serialization, maintenance and understanding hard;

You do not need to define schemas in order to interact with repositories, operations like all, insert_all and so on allow developers to directly access and modify the data, keeping the database at your fingertips when necessary;

```elixir
  defmodule Post do
    use Ecto.Schema

    schema "posts" do
      field :title, :string
      field :body, :string

      timestamps()
    end
  end
```
10. Run ```iex -S mix``` and type:
```elixir
post = %Post{title: "title", body: "content"}
Repo.insert(post)
Repo.delete!(post)
```
11. Although in the example above we have directly inserted and deleted the struct in the repository, operations on top of schemas are done through changesets so Ecto can efficiently track changes.

Changesets allow developers to filter, cast, and validate changes before we apply them to the data. Imagine the given schema:

```elixir
defmodule Post do
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :body, :string

    timestamps()
  end

  def changeset(post, params \\ %{}) do
    post
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
```

The changeset/2 function first invokes Ecto.Changeset.cast/4 with the struct, the parameters and a list of allowed fields; this returns a changeset. The parameters is a map with binary keys and values that will be cast based on the type defined on the schema.

Any parameter that was not explicitly listed in the fields list will be ignored.

After casting, the changeset is given to many Ecto.Changeset.validate_* functions that validate only the changed fields. In other words: if a field was not given as a parameter, it won’t be validated at all. For example, if the params map contain only the “name” and “email” keys, the “age” validation won’t run.

Once a changeset is built, it can be given to functions like insert and update in the repository that will return an :ok or :error tuple:

```elixir
  changeset = Post.changeset(%Post{}, %{title: "title"})
  case Repo.update(changeset) do
    {:ok, post} ->
    # post updated
    {:error, changeset} ->
    # an error occurred
  end
```

The benefit of having explicit changesets is that we can easily provide different changesets for different use cases. For example, one could easily provide specific changesets for publishing and updating posts:

```elixir
  def publishing_changeset(post, params) do
    # Changeset on publish
  end

  def update_changeset(post, params) do
    # Changeset on update
  end
```

Changesets are also capable of transforming database constraints, like unique indexes and foreign key checks, into errors. Allowing developers to keep their database consistent while still providing proper feedback to end users. Check Ecto.Changeset.unique_constraint/3 for some examples as well as the other _constraint functions.

12. Queries - Ecto allows you to write queries in Elixir and send them to the repository, which translates them to the underlying database. Let’s see an example:

```elixir
  import Ecto.Query, only: [from: 2]

  query = from p in Post,
            where: ilike(p.title, ^"%the best%"),
            select: p

  # Returns %Post{} structs matching the query
  Repo.all(query)
```

In the example above we relied on our schema but queries can also be made directly against a table by giving the table name as a string. In such cases, the data to be fetched must be explicitly outlined:

```elixir
  from p in "posts",
    where: ilike(p.title, ^"%the best%"),
    select: p
```
