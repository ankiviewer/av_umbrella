defmodule Av.Anki do
  @moduledoc false

  defmodule Helpers do
    def size_integer(map) when is_map(map),
      do: Map.new map, fn {k, v} -> {k, size_integer(v)} end
    def size_integer(string) when is_binary(string) do
      case Integer.parse(string) do
        {int, ""} -> size_integer int
        _ -> string
      end
    end
    def size_integer(int) when not is_integer(int),
      do: int
    def size_integer(int) when int < 10_000_000_000,
      do: int
    def size_integer(int) when int >= 10_000_000_000,
      do: Integer.floor_div int, 1000
  end

  defmodule Collection do
    use Ecto.Schema
    import Ecto.Changeset
    import Helpers

    schema "collection" do
      field :crt, :integer # created at
      field :mod, :integer # last modified at
      field :tags, {:array, :string} # array of strings of tags
    end

    @attrs ~w(crt mod tags)a
    def changeset(%Collection{} = collection, attrs) do
      collection
      |> cast(format(attrs), @attrs)
      |> validate_required(@attrs)
    end
    defp format(%{"crt" => crt, "mod" => mod, "tags" => tags}) do
      %{
        crt: crt,
        mod: mod,
        tags: Map.keys(tags)
      } |> size_integer
    end
  end

  defmodule Model do
    use Ecto.Schema
    import Ecto.Changeset
    import Helpers

    schema "models" do
      field :mid, :integer # model id
      field :did, :integer # deck id
      field :flds, {:array, :string} # e.g. {"Front", "Back"}
      field :mod, :integer # last modified at
    end

    @attrs ~w(mid did flds mod)a
    def changeset(%Model{} = model, attrs) do
      model
      |> cast(format(attrs), @attrs)
      |> validate_required(@attrs)
    end
    defp format(%{"name" => name, "did" => did, "flds" => flds, "mod" => mod, "id" => mid}) do
      %{
        name: name,
        did: did,
        flds: flds |> Enum.sort(&(&1["ord"] < &2["ord"])) |> Enum.map(&(&1["name"])),
        mod: mod,
        mid: mid
      } |> size_integer
    end
  end

  defmodule Deck do
    use Ecto.Schema
    import Ecto.Changeset
    import Helpers

    schema "decks" do
      field :did, :integer # deck id
      field :name, :string # deck name
      field :mod, :integer # last modified at
    end

    @attrs ~w(did name mod)a
    def changeset(%Deck{} = deck, attrs) do
      deck
      |> cast(format(attrs), @attrs)
      |> validate_required(@attrs)
    end
    defp format(%{"name" => name, "id" => did, "mod" => mod}) do
      %{name: name, did: did, mod: mod} |> size_integer
    end
  end

  defmodule Note do
    use Ecto.Schema
    import Ecto.Changeset
    import Helpers

    schema "notes" do
      field :cid, :integer # card id
      field :nid, :integer # note id
      field :cmod, :integer # card modified at
      field :nmod, :integer # note modified at
      field :mid, :integer # model id
      field :tags, :string # space seperated list of tags
      field :flds, :string # field 1 concatenated with field 2
      field :sfld, :string # just field 2
      field :did, :integer # deck id
      field :ord, :integer # which field was the question 0 or 1
      field :type, :integer # 0=new, 1=learning, 2=due
      field :queue, :integer # same as type with, -1=suspended, -2=user buried, -3=shed buried
      field :due, :integer # integer day relative to collections creation time
      field :reps, :integer # no of reviews
      field :lapses, :integer # no of times card went from answered correctly to not
    end

    @attrs ~w(cid nid cmod nmod mid tags flds sfld did ord type queue due reps lapses)a
    def changeset(%Note{} = note, attrs) do
      note
      |> cast(format(attrs), @attrs)
      |> validate_required(@attrs |> List.delete(:tags))
    end
    defp format(note) do
      size_integer note
    end
  end
end
