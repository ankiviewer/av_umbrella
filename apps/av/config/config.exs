use Mix.Config

config :av, ecto_repos: [Av.Repo]

config :bcrypt_elixir, log_rounds: 4

import_config "#{Mix.env}.exs"
