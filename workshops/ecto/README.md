# Create first app

1. Create app : ```mix new <app_name> --sup```
2. Add repo :
```elixir
defmodule Repo do
  use Ecto.Repo, otp_app: :app_name
end
```
3. Add worker :
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
9. Add schema :
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
```
