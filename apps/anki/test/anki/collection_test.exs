defmodule Anki.CollectionTest do
  use Anki.DataCase, async: false

  alias Anki.Collection

  test "Collection" do
    map = %{
      "decks" => ["DE", "Thai"],
      "mod" => 0,
      "models" => ["deen", "ende", "reverse", "thaidefault"],
      "tags" => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech"]
    }
    Collection.update map

    actual = %{}

    expected = %{}

    assert actual == expected
  end
end
