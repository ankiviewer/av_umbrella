defmodule Anki.Note do
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
  def changeset(%Note{} = note, attrs) do
    note
    |> cast(attrs, [:model, :deck, :tags, :mod, :one, :two, :rules_status])
    |> validate_required([:model, :deck, :tags, :mod, :one, :two, :rules_status])
  end
end
