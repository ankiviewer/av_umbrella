use Mix.Config

# Configure your database
config :anki, Anki.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "anki_dev",
  hostname: "localhost",
  pool_size: 10
