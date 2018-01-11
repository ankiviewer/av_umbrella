defmodule Av.TestHelpers do
  alias Av.{Repo, User}
  alias Av.Anki.Collection

  @valid_user_attrs %{name: "sam", password: "password"}
  @valid_collection_attrs %{"crt" => 1111111111, "mod" => 1111111111111, "tags" => %{"hello" => 0, "world" => 0}}
  def insert_user(attrs \\ %{}) do
    changes = Enum.into attrs, @valid_user_attrs

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_collection(attrs \\ %{}) do
    changes = Enum.into attrs, @valid_collection_attrs

    %Collection{}
    |> Collection.changeset(changes)
    |> Repo.insert!
  end

  def size_integer(map) when is_map(map),
    do: Map.new map, fn {k, v} -> {k, size_integer(v)} end
  def size_integer(int) when not is_integer(int),
    do: int
  def size_integer(int) when int < 10_000_000_000,
    do: int
  def size_integer(int) when int >= 10_000_000_000,
      do: Integer.floor_div int, 1000
end
