defmodule Av.AnkiTest do
  use Av.DataCase, async: false
  doctest Av.Anki.Note, import: true

  require Poison
  alias Av.Anki.{Collection, Model, Deck, Note, Helpers}

  @nodeapp __DIR__ <> "/../../../../nodeapp"
  @models @nodeapp <> "/test/models.json"
          |> File.read!
          |> Poison.decode!
  @collection @models |> Map.get("collection")
  @notes @models |> Map.get("notes")

  test "helpers" do
    [
      {%{h: "hello", e: "ello", l: "llo"},
        %{h: "hello", e: "ello", l: "llo"}},
      {"hello", "hello"},
      {1_482_060_876_072, 1_482_060_876},
      {1_482_060_876, 1_482_060_876},
      {"1482060876072", 1_482_060_876},
      {"1482060876", 1_482_060_876},
    ] |> Enum.each(fn {input, expected} ->
      assert Helpers.size_integer(input) == expected
    end)
  end

  describe "collection" do
    test "changeset" do
      changeset = %Collection{} |> Collection.changeset(@collection)

      assert changeset.valid?
      assert changeset.changes.crt == @collection["crt"]
      assert changeset.changes.mod == size_integer(@collection["mod"])
      assert changeset.changes.tags == Map.keys(@collection["tags"])
    end

    test "insert" do
      {:ok, %Collection{}} = %Collection{}
      |> Collection.changeset(@collection)
      |> Repo.insert
    end
  end

  describe "model" do
    test "changeset" do
      for model <- Map.values(@collection["models"]) do
        changeset = %Model{} |> Model.changeset(model)

        assert changeset.valid?
        assert changeset.changes.did == size_integer(model["did"])
        flds = model["flds"]
               |> Enum.sort(&(&1["ord"] < &2["ord"]))
               |> Enum.map(&(&1["name"]))
        assert changeset.changes.flds == flds
        assert changeset.changes.mod == model["mod"]
        assert changeset.changes.mid == size_integer(model["id"])
      end
    end

    test "insert" do
      for model <- Map.values(@collection["models"]) do
        {:ok, %Model{}} = %Model{}
                          |> Model.changeset(model)
                          |> Repo.insert
      end
    end
  end

  describe "deck" do
    test "changeset" do
      for deck <- Map.values(@collection["decks"]) do
        changeset = %Deck{} |> Deck.changeset(deck)

        assert changeset.valid?
        assert changeset.changes.name == deck["name"]
        assert changeset.changes.mod == deck["mod"]
        assert changeset.changes.did == size_integer(deck["id"])
      end
    end

    test "insert" do
      for deck <- Map.values(@collection["decks"]) do
        {:ok, %Deck{}} = %Deck{}
                         |> Deck.changeset(deck)
                         |> Repo.insert
      end
    end
  end

  describe "note" do
    test "changeset" do
      for note <- @notes do
        changeset = %Note{} |> Note.changeset(note)

        assert changeset.valid?
      end
    end

    test "insert" do
      for note <- @notes do
        {:ok, %Note{}} = %Note{}
                       |> Note.changeset(note)
                       |> Repo.insert
      end
    end
  end

  describe "extra_fields" do
    test "starts_with?" do
      note = %{flds: "the sidedie Seite", sfld: "the side"}
      actual = Note.extra_fields note

      assert actual.front == "the side"
      assert actual.back == "die Seite"
    end

    test "ends_with?" do
      note = %{flds: "die Seitethe side/ page", sfld: "the side/ page"}
      actual = Note.extra_fields note

      assert actual.front == "die Seite"
      assert actual.back == "the side/ page"
    end
  end
end
