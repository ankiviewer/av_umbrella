# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Av.Repo.insert!(%Av.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Av.{Repo, User}

users = [
  %{name: "s", password: "password"},
  %{name: "v", password: "password"},
]

for user <- users do
  %User{}
  |> User.registration_changeset(user)
  |> Repo.insert!
end
