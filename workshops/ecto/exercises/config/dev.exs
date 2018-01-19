use Mix.Config

config :ecto_exercises, Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_exercises",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
