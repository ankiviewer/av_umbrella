defmodule Anki.Note do
  @moduledoc false

  use Ecto.Schema

  schema "notes" do
    add :model, :string
    add :deck, :string
    add :tags, {:array, :string}
    add :mod, :date
    add :one, :string
    add :two, :string
    add :rules_status, {:array, :string}
  end
end
