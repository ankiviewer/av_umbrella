use Mix.Config

config :av, Av.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "av_dev",
  hostname: "localhost",
  pool_size: 10
