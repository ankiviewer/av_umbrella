defmodule AvWeb.SearchControllerTest do
  use AvWeb.ConnCase

  defp extra_fields(%{"flds" => flds, "sfld" => sfld} = note) do
    if String.ends_with? flds, sfld do
      with one <- String.trim_trailing(flds, sfld),
           two <- sfld,
      do: Map.merge note, %{"one" => one, "two" => two}
    else
      raise "Not matched! #{flds} and #{sfld}"
    end
  end

  describe "collection" do
    test "without Collection" do
      conn = get build_conn(), "/api/collection"
      actual = json_response conn, 200
      expected = %{"error" => "Collection not loaded", "payload" => nil}

      assert actual == expected
    end

    test "with Collection" do
      insert_collection()

      conn = get build_conn(), "/api/collection"
      actual = json_response conn, 200
      expected = %{"error" => "Models not loaded", "payload" => nil}

      assert actual == expected
    end

    test "with Collection and Model" do
      insert_collection()
      insert_models()

      conn = get build_conn(), "/api/collection"
      actual = json_response conn, 200
      expected = %{"error" => "Decks not loaded", "payload" => nil}

      assert actual == expected
    end

    test "with Collection, Model and Deck" do
      insert_collection()
      insert_models()
      insert_decks()

      conn = get build_conn(), "/api/collection"
      actual = json_response conn, 200
      payload = %{
        "collection" => %{
          "crt" => 1_111_111_111,
          "mod" => 1_111_111_111,
          "tags" => ["hello", "world"]
        },
        "decks" => [
          %{"did" => 1,
            "mod" => 1_482_840_611,
            "name" => "Default"
          },
          %{"did" => 1_482_060_876,
            "mod" => 1_514_645_269,
            "name" => "DE"
          },
          %{"did" => 1_503_955_755,
            "mod" => 1_514_645_455,
            "name" => "Thai"
          }
        ],
        "models" => [
          %{
            "did" => 1,
            "flds" => ["Front", "Back"],
            "mid" => 1_507_832_105,
            "mod" => 1_507_832_120
          },
          %{
            "did" => 1_482_060_876,
            "flds" => ["English", "German", "Hint"],
            "mid" => 1_482_844_395,
            "mod" => 1_498_897_458
          },
          %{
            "did" => 1_482_060_876,
            "flds" => ["German", "English", "Hint"],
            "mid" => 1_482_842_770,
            "mod" => 1_514_653_350
          }
        ]
      }
      # TODO: allow error to take different types
      expected = %{"error" => "", "payload" => payload}

      assert actual == expected
    end
  end

  describe "notes" do
    test "without notes" do
      conn = get build_conn(), "/api/notes"
      actual = json_response conn, 200
      expected = %{"error" => "Notes not loaded", "payload" => nil}

      assert actual == expected
    end

    test "with notes" do
      insert_notes()
      conn = get build_conn(), "/api/notes"
      actual = json_response conn, 200
      payload = [
        %{
          "cid" => 1_506_600_429,
          "cmod" => 1_510_927_123,
          "did" => 1_482_060_876,
          "due" => 412,
          "flds" => "Unnützunuseful",
          "lapses" => 0,
          "mid" => 1_482_842_770,
          "nid" => 1_506_600_417,
          "nmod" => 1_506_600_429,
          "ord" => 0,
          "queue" => 2,
          "reps" => 6,
          "sfld" => "unuseful",
          "tags" => nil,
          "type" => 2
        },
        %{
          "cid" => 1_506_600_429,
          "cmod" => 1_514_058_424,
          "did" => 1_482_060_876,
          "due" => 417,
          "flds" => "Unnützunuseful",
          "lapses" => 2,
          "mid" => 1_482_842_770,
          "nid" => 1_506_600_417,
          "nmod" => 1_506_600_429,
          "ord" => 1,
          "queue" => 2,
          "reps" => 13,
          "sfld" => "unuseful",
          "tags" => nil,
          "type" => 2
        },
        %{
          "cid" => 1_506_600_538,
          "cmod" => 1_510_071_661,
          "did" => 1_482_060_876,
          "due" => 392,
          "flds" => "reizento irritate (skin)",
          "lapses" => 0,
          "mid" => 1_482_842_770,
          "nid" => 1_506_600_526,
          "nmod" => 1_506_600_538,
          "ord" => 0,
          "queue" => 2,
          "reps" => 7,
          "sfld" => "to irritate (skin)",
          "tags" => nil,
          "type" => 2
        },
        %{
          "cid" => 1_506_600_538,
          "cmod" => 1_514_507_902,
          "did" => 1_482_060_876,
          "due" => 390,
          "flds" => "reizento irritate (skin)",
          "lapses" => 5,
          "mid" => 1_482_842_770,
          "nid" => 1_506_600_526,
          "nmod" => 1_506_600_538,
          "ord" => 1,
          "queue" => 2,
          "reps" => 28,
          "sfld" => "to irritate (skin)",
          "tags" => nil,
          "type" => 2
        }
      ]
      payload = Enum.map payload, &(Map.merge &1, %{"ttype" => &1["type"]})
      payload = Enum.map payload, &extra_fields/1
      expected = %{"error" => "", "payload" => payload}

      assert actual == expected
    end
  end
end
