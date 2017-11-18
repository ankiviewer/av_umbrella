defmodule Anki.Note do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.Note

  schema "notes" do
    field :deck, :string
    field :mod, :date
    field :model, :string
    field :one, :string
    field :rules_status, {:array, :string}
    field :tags, {:array, :string}
    field :two, :string

    timestamps()
  end

  @doc false
  @attrs [:model, :deck, :tags, :mod, :one, :two, :rules_status]
  def changeset(%Note{} = note, attrs) do
    note
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end
end
