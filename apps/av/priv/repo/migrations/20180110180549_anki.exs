defmodule Av.Repo.Migrations.Anki do
  use Ecto.Migration

  def change do
    create table(:collection) do
      add :crt, :integer
      add :mod, :integer
      add :tags, {:array, :string}
    end

    create table(:models) do
      add :mid, :integer
      add :did, :integer
      add :flds, {:array, :string}
      add :mod, :integer
      add :name, :string
    end

    create table(:decks) do
      add :did, :integer
      add :name, :string
      add :mod, :integer
    end

    create table(:notes) do
      add :cid, :integer
      add :nid, :integer
      add :cmod, :integer
      add :nmod, :integer
      add :mid, :integer
      add :tags, :string
      add :flds, :string
      add :sfld, :string
      add :did, :integer
      add :ord, :integer
      add :type, :integer
      add :queue, :integer
      add :due, :integer
      add :reps, :integer
      add :lapses, :integer
    end
  end
end
