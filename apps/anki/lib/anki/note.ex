defmodule Anki.Note do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.{Note, Repo}

  schema "notes" do
    field :deck, :string
    field :mod, :date
    field :model, :string
    field :one, :string
    field :rules_status, {:array, :string}
    field :tags, {:array, :string}
    field :two, :string
    field :anki_note_id, :integer

    timestamps()
  end

  @doc false
  @required_fields [:model, :deck, :tags, :mod, :one, :two, :anki_note_id]
  @optional_fields [:rules_status]
  def changeset(%Note{} = note, attrs) do
    note
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  @doc"""
  Takes a list of notes and updates the note table with this data
  This shouldn't duplicate notes in the database
  """
  def update!(attrs) do
    attrs
    |> Enum.map(
      fn n ->
        %Note{}
        |> Note.changeset(
          Map.new(
            n,
            fn {k, v} ->
              case k do
                :tags -> {k, String.split(v)}
                :mod -> {k, ~D[2017-01-01]}
                _ -> {k, v}
              end
            end
          )
        )
        |> Repo.insert!
      end
    )
  end
end
