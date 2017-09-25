use Mix.Config

# Configure your database
config :anki, Anki.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "anki_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
