defmodule Anki.Collection do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.{Collection, Repo}

  schema "collection" do
    field :decks, {:array, :string}
    field :mod, :date
    field :models, {:array, :string}
    field :tags, {:array, :string}

    timestamps()
  end

  @doc false
  @attrs [:decks, :mod, :models, :tags]
  def changeset(%Collection{} = collection, attrs) do
    collection
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end

  @doc"""
  Takes a map and updates the collection table with it
  If there is no collection it creates it
  If a collection exists, it replaces it
  """
  def update!(attrs) do
    Collection
    |> Repo.one
    |> case do
      nil -> %Collection{}
      collection -> collection
    end
    |> Collection.changeset(attrs)
    |> Repo.insert_or_update!
  end
end
