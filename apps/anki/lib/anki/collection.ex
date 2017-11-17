defmodule Anki.Collection do
  @moduledoc false

  use Ecto.Schema

  schema "collection" do
    field :decks, {:array, :string}
    field :mod, :date,
    field :models, {:array, :string}
    field :tags, {:array, :string}
  end
end
