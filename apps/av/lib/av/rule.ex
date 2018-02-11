defmodule Av.Rule do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Av.{Rule, Repo, Anki.Note}

  schema "rules" do
    field :comment, :string
    field :fail, :boolean, default: false
    field :nid, :integer
    field :rid, :integer
    field :url, :string

    timestamps()
  end

  @required_fields ~w(nid rid fail)a
  @optional_fields ~w(comment url)a
  def changeset(%Rule{} = rule, attrs \\ %{}) do
    rule
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def insert!(%Rule{} = rule) do
    rule
    |> changeset
    |> Repo.insert!
  end

  def all do
    rules = Rule
            |> select([r], %{rid: r.rid, fail: r.fail})
            |> Repo.all
    Enum.map list(), fn r ->
      rid_rules = rules |> Enum.filter(&(&1.rid == r.rid))
      total = rid_rules |> length
      failing = rid_rules |> Enum.filter(&(&1.fail)) |> length
      Map.merge r, %{total: total, failing: failing}
    end
  end

  def all(rid) do
    Rule
    |> where([r], r.rid == ^rid)
    |> join(:inner, [r], n in Note)
    |> where([r, n], r.nid == n.nid)
    |> select([r, n], %{name: name, fail: r.fail, front: n.sfld})
    |> Repo.all
  end

  def list do
    [
      %{
        rid: 1,
        name: "Repeated 'front'"
      }
    ]
  end

  def list(rid),
    do: Enum.find list(), &(&1.rid == rid)

  @doc"""
  Returns map of %{fail: boolean} with optional keys of comment and url
  """
  def rule(rid, notes, note) do
    case rid do
      1 -> 
        fail = Enum.any? notes, fn n ->
          n.front == note.front
          and n.nid != note.nid
        end
        %{fail: fail, rid: rid}
      _ ->
        raise "Unknown rule id: #{rid}"
    end
  end
end
