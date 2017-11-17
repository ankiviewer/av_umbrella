defmodule Anki.Collection do
  @moduledoc false

  use Ecto.Schema

  alias Anki.{Collection, Repo}

  schema "collection" do
    field :decks, {:array, :string}
    field :mod, :date
    field :models, {:array, :string}
    field :tags, {:array, :string}
  end

  @doc"""
  Updates collection table of database from given map
  """
  def update(map) do
    Repo.insert(%Collection{decks: ["one", "two"], mod: ~D[2000-01-01], models: ["one", "two"], tags: ["one", "two"]})
  end
end
