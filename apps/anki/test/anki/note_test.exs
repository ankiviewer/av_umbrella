defmodule Anki.NoteTest do
  use Anki.DataCase, async: false
  doctest Anki.Note, import: true

  alias Anki.{Note, Repo, TestHelpers}

  require Poison

  test "Updating Notes" do
    Note.delete!

    notes = "#{__DIR__}/../../node_app/test/models.json"
    |> File.read!
    |> Poison.decode!
    |> Map.fetch!("formattedNotes")

    for note <- notes do
      note
      |> Note.format!
      |> Note.insert!
    end

    actual = Note
    |> Repo.all
    |> TestHelpers.sanitize
    |> Enum.map(&Map.drop &1, [:rules_status])

    expected = notes
    |> Note.format!
    |> TestHelpers.sanitize

    assert actual == expected
  end
end
