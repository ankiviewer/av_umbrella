defmodule Anki.Repo.Migrations.AddAnkiNoteId do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :anki_note_id, :string
    end
  end
end
