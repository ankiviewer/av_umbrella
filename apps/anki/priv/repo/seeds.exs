# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Anki.Repo.insert!(%Anki.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Anki.{Collection, Note}

"/collection"
|> Anki.request!
|> Collection.format!
|> Collection.update!

Note.delete!

"/notes"
|> Anki.request!

for note <- Anki.request! "/notes" do
  note
  |> Note.format!
  |> Note.insert!
end
