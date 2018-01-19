use Mix.Config

config :ecto_exercises, Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_exercises",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
