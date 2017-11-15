use Mix.Config

config :anki, ecto_repos: [Anki.Repo]
config :porcelain, driver: Porcelain.Driver.Goon

import_config "#{Mix.env}.exs"
