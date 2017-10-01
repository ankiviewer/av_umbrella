use Mix.Config

config :anki, ecto_repos: [Anki.Repo], httpoison: Anki.HTTPoison.HTTPoison
config :porcelain, driver: Porcelain.Driver.Goon

import_config "#{Mix.env}.exs"
