defmodule Anki.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :model, :string
      add :deck, :string
      add :tags, {:array, :string}
      add :mod, :date
      add :one, :string
      add :two, :string
      add :rules_status, {:array, :string}

      timestamps()
    end

  end
end
