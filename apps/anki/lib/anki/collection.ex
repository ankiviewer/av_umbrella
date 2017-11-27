defmodule Anki.Collection do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.{Collection, Repo}

  schema "collection" do
    field :decks, {:array, :string}
    field :mod, :string
    field :models, {:array, :string}
    field :tags, {:array, :string}

    timestamps()
  end

  @attrs ~w(decks mod models tags)a
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
  def update!(collection) do
    Collection
    |> Repo.one
    |> case do
      nil -> %Collection{}
      coll -> coll
    end
    |> Collection.changeset(collection)
    |> Repo.insert_or_update!
  end

  def format_decks(decks) do
    decks
    |> Map.values
    |> Enum.map(fn %{"name" => n} -> n end)
    |> Enum.filter(&(&1 != "Default"))
  end
  def format_models(models),
    do: format_decks models
  def format_tags(tags),
    do: Map.keys tags

  def format(collection_request) do
    collection_request
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    |> Map.new(
      fn {k, v} ->
        case k do
          :decks -> {k, format_decks v}
          :models -> {k, format_models v}
          :tags -> {k, format_tags v}
          :mod -> {k, "#{v}"}
          _ -> {k, v}
        end
      end
    )
  end
end
