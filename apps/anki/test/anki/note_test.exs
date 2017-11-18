defmodule Anki.NoteTest do
  use Anki.DataCase, async: false

  alias Anki.{Note, Repo, TestHelpers}

  require Poison

  describe "Note.update" do
    test "without initial note data" do
      notes = "#{__DIR__}/../../node_app/test/models.json"
      |> File.read!()
      |> Poison.decode!
      |> Map.fetch!("formattedNotes")
      |> Enum.map(
        fn n -> 
          Map.new(
            n, 
            fn {k, v} -> {String.to_atom(k), v} end
          )
        end
      )

      Note.update! notes

      actual = Note |> Repo.all
      expected = notes

      actual == expected
    end
  end
end
