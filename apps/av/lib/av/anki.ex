defmodule Av.Anki do
  @moduledoc false
  defmodule Collection do
    use Ecto.Schema
    import Ecto.Changeset

    schema "collection" do
      field :crt, :integer # created at
      field :mod, :integer # last modified at
      field :tags, :string # space seperated string of tags

      timestamps()
    end

    @attrs ~w(crt mod tags)a
    def changeset(%Collection{} = collection, attrs \\ %{}) do
      collection
      |> cast(attrs, @attrs)
      |> validate_required(@attrs)
    end
  end

  defmodule Model do
    use Ecto.Schema
    import Ecto.Changeset

    schema "models" do
      field :mid, :integer # model id
      field :did, :integer # deck id
      field :flds, {:array, :string} # e.g. {"Front", "Back"}
      field :mod, :integer # last modified at
    end

    @attrs ~w(mid did flds mod)a
    def changeset(%Deck{} = note, attrs \\ %{}) do
      note
      |> cast(attrs, @attrs)
      |> validate_required(@attrs)
    end
  end

  defmodule Deck do
    use Ecto.Schema
    import Ecto.Changeset

    schema "decks" do
      field :did, :integer # deck id
      field :name, :string # deck name
      field :mod, :integer # last modified at
    end

    @attrs ~w(did name mod)a
    def changeset(%Deck{} = note, attrs \\ %{}) do
      note
      |> cast(attrs, @attrs)
      |> validate_required(@attrs)
    end
  end

  defmodule Note do
    use Ecto.Schema
    import Ecto.Changeset

    schema "notes" do
      field :cid, :integer # card id
      field :nid, :integer # note id
      field :cmod, :integer # card modified at
      field :nmod, :integer # note modified at
      field :mid, :integer # model id
      field :tags, :string # space seperated list of tags
      field :flds, :string # field 1 concatenated with field 2
      field :sfld, :string # just field 2
      field :did, :integer # deck id
      field :ord, :integer # which field was the question 0 or 1
      field :type, :integer # 0=new, 1=learning, 2=due
      field :queue, :integer # same as type with, -1=suspended, -2=user buried, -3=shed buried
      field :due, :integer # integer day relative to collections creation time
      field :reps, :integer # no of reviews
      field :lapses, :integer # no of times card went from answered correctly to not

      timestamps()
    end

    @attrs ~w(cid nid cmod nmod mid tags flds sfld did ord type queue due reps lapses)a
    def changeset(%Note{} = note, attrs \\ %{}) do
      note
      |> cast(attrs, @attrs)
      |> validate_required(@attrs)
    end
  end
end
