use Mix.Config

config :av, ecto_repos: [Av.Repo]

import_config "#{Mix.env}.exs"
