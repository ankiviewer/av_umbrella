defmodule Anki.CollectionTest do
  use Anki.DataCase, async: false

  alias Anki.{Collection, Repo, TestHelpers}
  import TestHelpers, only: [sort_lists: 1]

  describe "formatting" do
    test "format_decks" do
      decks = %{
        "1" =>%{"name" => "Default"},
        "123456" => %{"name" => "DE"},
        "654321" => %{"name" => "Thai"}
      }

      actual = Collection.format_decks decks
      expected = ["DE", "Thai"]

      assert actual == expected
    end

    test "format_models" do
      models = %{
        "1234" => %{"name" => "deen"},
        "1235" => %{"name" => "ende"},
        "1236" => %{"name" => "reverse"},
        "7654" => %{"name" => "thaidefault"}
      }
      actual = Collection.format_models models
      expected = ["deen", "ende",
                  "reverse", "thaidefault"]
      
      assert actual == expected
    end

    test "format_tags" do
      tags = %{"duplicate" => 0,
               "leech" => 0,
               "marked" => 0,
               "sentence" => 0,
               "to-restructure" => 0,
               "verb" => 0,
               "verified-by-vanessa" => 0}
      actual = Collection.format_tags tags
      expected = ["sentence", "marked",
                  "duplicate", "verb",
                  "to-restructure", "leech",
                  "verified-by-vanessa"]
      
      assert sort_lists(actual) == sort_lists(expected)
    end

    test "format" do
      collection_request = %{
        "decks" => %{
          "1" => %{"name" => "Default"},
          "123456" => %{"name" => "DE"},
          "654321" => %{"name" => "Thai"}},
        "mod" => 1507832160,
        "models" => %{
          "1234" => %{"name" => "deen"},
          "1235" => %{"name" => "ende"},
          "1236" => %{"name" => "reverse"},
          "7654" => %{"name" => "thaidefault"}
        },
        "tags" => %{
          "duplicate" => 0,
          "leech" => 0,
          "marked" => 0,
          "sentence" => 0,
          "to-restructure" => 0,
          "verb" => 0,
          "verified-by-vanessa" => 0
        }
      }
      actual = Collection.format(collection_request)
      expected = %{
        :decks => ["DE", "Thai"],
        :mod => "1507832160",
        :models => ["deen", "ende", "reverse", "thaidefault"],
        :tags => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech", "verified-by-vanessa"]
      }
      assert sort_lists(actual) == sort_lists(expected)
    end
  end

  describe "Collection.update" do
    test "without initial collection data" do
      attrs = %{
        :decks => ["DE", "Thai"],
        :mod => "1507832160",
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
        :mod => "1507832160",
        :models => ["deen", "ende", "reverse", "thaidefault"],
        :tags => ["sentence", "marked", "duplicate", "verb", "to-restructure", "leech"]
      }

      Collection.update! attrs

      new_attrs = %{
        :decks => ["DE"],
        :mod => "1507832160",
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
