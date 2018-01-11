defmodule Av.AnkiTest do
  use Av.DataCase, async: false

  require Poison
  alias Av.Anki.{Collection, Model, Deck, Note}

  @nodeapp __DIR__ <> "/../../../../nodeapp"
  @models @nodeapp <> "/test/models.json"
          |> File.read!
          |> Poison.decode!
  @collection @models |> Map.get("collection")
  @notes @models |> Map.get("notes")

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
end
