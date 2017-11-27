defmodule Anki.Note do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.{Note, Repo}

  schema "notes" do
    field :deck, :string
    field :mod, :string
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
  iex>format(%{"one" => "hello", "tags" => "hello world", "mod" => 1486035766})
  %{one: "hello", tags: ["hello", "world"], mod: "1486035766"}
  iex>format([%{"one" => "hello", "tags" => "hello world", "mod" => 1486035766}])
  [%{one: "hello", tags: ["hello", "world"], mod: "1486035766"}]
  """
  def format(map) when is_map(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    |> Map.new(
      fn {k, v} ->
        case k do
          :tags -> {k, String.split v}
          :mod -> {k, "#{v}"}
          _ -> {k, v}
        end
      end
    )
  end

  def format(list) when is_list(list),
    do: Enum.map list, &format/1

  @doc"""
  Takes a list of notes and updates the note table with this data
  This shouldn't duplicate notes in the database
  """
  def update!(notes) when is_list(notes) do
    # TODO: check collection is also up to date and update this if not
    for old_note <- Repo.all(Note),
      do: Repo.delete! old_note

    for note <- notes do
      with note <- format(note),
        do: %Note{} |> Note.changeset(note) |> Repo.insert!
    end
  end
end
