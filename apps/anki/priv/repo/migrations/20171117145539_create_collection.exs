defmodule Anki.Repo.Migrations.CreateCollection do
  use Ecto.Migration

  def change do
    create table(:collection) do
      add :decks, {:array, :string}
      add :mod, :date
      add :models, {:array, :string}
      add :tags, {:array, :string}

      timestamps()
    end

  end
end
