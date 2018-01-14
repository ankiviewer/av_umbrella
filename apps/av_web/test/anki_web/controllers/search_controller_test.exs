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
          "crt" => 1111111111,
          "mod" => 1111111111,
          "tags" => ["hello", "world"]
        },
        "decks" => [
          %{"did" => 1,
            "mod" => 1482840611,
            "name" => "Default"
          },
          %{"did" => 1482060876,
            "mod" => 1514645269,
            "name" => "DE"
          },
          %{"did" => 1503955755,
            "mod" => 1514645455,
            "name" => "Thai"
          }
        ],
        "models" => [
          %{
            "did" => 1,
            "flds" => ["Front", "Back"],
            "mid" => 1507832105,
            "mod" => 1507832120
          },
          %{
            "did" => 1482060876,
            "flds" => ["English", "German", "Hint"],
            "mid" => 1482844395,
            "mod" => 1498897458
          },
          %{
            "did" => 1482060876,
            "flds" => ["German", "English", "Hint"],
            "mid" => 1482842770,
            "mod" => 1514653350
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
          "cid" => 1506600429,
          "cmod" => 1510927123,
          "did" => 1482060876,
          "due" => 412,
          "flds" => "Unnützunuseful",
          "lapses" => 0,
          "mid" => 1482842770,
          "nid" => 1506600417,
          "nmod" => 1506600429,
          "ord" => 0,
          "queue" => 2,
          "reps" => 6,
          "sfld" => "unuseful",
          "tags" => nil,
          "type" => 2
        },
        %{
          "cid" => 1506600429,
          "cmod" => 1514058424,
          "did" => 1482060876,
          "due" => 417,
          "flds" => "Unnützunuseful",
          "lapses" => 2,
          "mid" => 1482842770,
          "nid" => 1506600417,
          "nmod" => 1506600429,
          "ord" => 1,
          "queue" => 2,
          "reps" => 13,
          "sfld" => "unuseful",
          "tags" => nil,
          "type" => 2
        },
        %{
          "cid" => 1506600538,
          "cmod" => 1510071661,
          "did" => 1482060876,
          "due" => 392,
          "flds" => "reizento irritate (skin)",
          "lapses" => 0,
          "mid" => 1482842770,
          "nid" => 1506600526,
          "nmod" => 1506600538,
          "ord" => 0,
          "queue" => 2,
          "reps" => 7,
          "sfld" => "to irritate (skin)",
          "tags" => nil,
          "type" => 2
        },
        %{
          "cid" => 1506600538,
          "cmod" => 1514507902,
          "did" => 1482060876,
          "due" => 390,
          "flds" => "reizento irritate (skin)",
          "lapses" => 5,
          "mid" => 1482842770,
          "nid" => 1506600526,
          "nmod" => 1506600538,
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
