use Mix.Config

# Configure your database
config :anki, Anki.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "anki_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 10 * 60 * 1000

config :anki, :httpoison, Anki.HTTPoison.InMemory
