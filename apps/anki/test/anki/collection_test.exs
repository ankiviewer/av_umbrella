defmodule Anki.CollectionTest do
  use Anki.DataCase, async: false

  alias Anki.{Collection, Repo, TestHelpers}

  describe "Collection.update" do
    test "without initial collection data" do
      attrs = %{
        :decks => ["DE", "Thai"],
        :mod => ~D[2000-01-01],
        :models => ["deen", "ende", "reverse", "thaidefault"],
        :tags => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech"]
      }

      Collection.update! attrs

      actual = Collection |> Repo.one! |> TestHelpers.sanitize
      expected = %Collection{} |> Map.merge(attrs) |> TestHelpers.sanitize

      assert actual == expected
    end

    test "with initial collection data" do
      attrs = %{
        :decks => ["DE", "Thai"],
        :mod => ~D[2000-01-01],
        :models => ["deen", "ende", "reverse", "thaidefault"],
        :tags => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech"]
      }

      Collection.update! attrs

      new_attrs = %{
        :decks => ["DE"],
        :mod => ~D[2000-01-01],
        :models => ["deen", "ende", "reverse", "thaidefault", "other"],
        :tags => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech"]
      }

      Collection.update! new_attrs

      actual = Collection |> Repo.one! |> TestHelpers.sanitize
      expected = %Collection{} |> Map.merge(new_attrs) |> TestHelpers.sanitize

      assert actual == expected
    end
  end
end
