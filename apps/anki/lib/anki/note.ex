defmodule Anki.Note do
  @moduledoc false

  use Ecto.Schema

  schema "notes" do
    field :model, :string
    field :deck, :string
    field :tags, {:array, :string}
    field :mod, :date
    field :one, :string
    field :two, :string
    field :rules_status, {:array, :string}
  end
end
