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
  iex>format(%{one: "hello", tags: "hello world", mod: 123456})
  %{one: "hello", tags: ["hello", "world"], mod: ~D[2017-01-01]}
  iex>format(%{one: "hello", tags: ["hello", "world"], mod: ~D[2017-01-01]})
  %{one: "hello", tags: ["hello", "world"], mod: ~D[2017-01-01]}
  """
  def format(map) do
    map
    |> Map.new(
      fn {k, v} ->
        case is_binary(k) do
          true -> {String.to_atom(k), v}
          false -> {k, v}
        end
      end
    )
    |> Map.new(
      fn {k, v} ->
        case k do
          :tags -> {
            k,
            if is_list(v) do
              v
            else
              String.split(v)
            end
          }
          :mod -> {k, ~D[2017-01-01]}
          _ -> {k, v}
        end
      end
    )
  end

  @doc"""
  Takes a list of notes and updates the note table with this data
  This shouldn't duplicate notes in the database
  """
  def update!(attrs) do
    attrs
    |> Enum.each(
      fn n ->
        %Note{}
        |> Note.changeset(format(n))
        |> Repo.insert!
      end
    )
  end
end
