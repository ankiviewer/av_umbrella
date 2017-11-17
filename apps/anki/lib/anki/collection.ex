defmodule Anki.Collection do
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.Collection


  schema "collection" do
    field :decks, {:array, :string}
    field :mod, :date
    field :models, {:array, :string}
    field :tags, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(%Collection{} = collection, attrs) do
    collection
    |> cast(attrs, [:decks, :mod, :models, :tags])
    |> validate_required([:decks, :mod, :models, :tags])
  end
end
