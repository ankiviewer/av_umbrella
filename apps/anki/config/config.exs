use Mix.Config

config :anki, ecto_repos: [Anki.Repo]

import_config "#{Mix.env}.exs"
