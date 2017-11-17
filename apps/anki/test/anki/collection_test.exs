defmodule Anki.CollectionTest do
  use Anki.DataCase, async: false

  alias Anki.{Collection, Repo}

  test "Collection" do
    attrs = %{
      "decks" => ["DE", "Thai"],
      "mod" => 0,
      "models" => ["deen", "ende", "reverse", "thaidefault"],
      "tags" => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech"]
    }

    changeset = Collection.changeset %Collection{}, attrs

    actual = Repo.insert! changeset

    expected = %{}

    assert actual == expected
  end
end
