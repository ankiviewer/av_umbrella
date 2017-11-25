defmodule Anki.Note do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Anki.{Note, Repo}

  schema "notes" do
    field :deck, :string
    field :mod, :naive_datetime
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
  iex>format(%{one: "hello", tags: "hello world", mod: 1486035766})
  %{one: "hello", tags: ["hello", "world"], mod: ~N[2017-02-02 11:42:46]}
  iex>format([%{one: "hello", tags: "hello world", mod: 1486035766}])
  [%{one: "hello", tags: ["hello", "world"], mod: ~N[2017-02-02 11:42:46]}]
  """
  def format(map) when is_map(map) do
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
          :tags -> {k, if is_binary(v) do String.split(v) else v end}
          :mod -> {k, DateTime.to_naive(DateTime.from_unix!(v))}
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
