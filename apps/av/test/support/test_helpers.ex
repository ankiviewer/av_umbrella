defmodule Av.TestHelpers do
  alias Av.{Repo, User}
  alias Av.Anki.{Collection, Model, Note, Deck}

  @valid_user_attrs %{name: "sam", password: "password"}
  @valid_collection_attrs %{"crt" => 1111111111, "mod" => 1111111111111, "tags" => %{"hello" => 0, "world" => 0}}
  @valid_model_attrs [
    %{
      "name" => "Basic (and reversed card)",
      "did" => 1,
      "flds" => [
        %{ "name" => "Front", "ord" => 0 },
        %{ "name" => "Back", "ord" => 1 }
      ],
      "mod" => 1507832120,
      "id" => 1507832105615
    },
    %{
      "name" => "en_de",
      "did" => 1482060876072,
      "flds" => [
        %{ "name" => "English", "ord" => 0 },
        %{ "name" => "German", "ord" => 1 },
        %{ "name" => "Hint", "ord" => 2 }
      ],
      "mod" => 1498897458,
      "id" => 1482844395181
    },
    %{
      "name" => "de_reverse",
      "did" => 1482060876072,
      "flds" => [
        %{ "name" => "German", "ord" => 0 },
        %{ "name" => "English", "ord" => 1 },
        %{ "name" => "Hint", "ord" => 2 }
      ],
      "mod" => 1514653350,
      "id" => 1482842770192
    }
  ]
  @valid_deck_attrs [
    %{
      "name" => "Default",
      "mod" => 1482840611,
      "id" => 1
    },
    %{
      "name" => "DE",
      "mod" => 1514645269,
      "id" => 1482060876072
    },
    %{
      "name" => "Thai",
      "mod" => 1514645455,
      "id" => 1503955755113
    }
  ]
  @valid_note_attrs [
    %{
      "cid" => 1506600429296,
      "nid" => 1506600417828,
      "cmod" => 1510927123,
      "nmod" => 1506600429,
      "mid" => 1482842770192,
      "tags" => "",
      "flds" => "Unnützunuseful",
      "sfld" => "unuseful",
      "did" => 1482060876072,
      "ord" => 0,
      "type" => 2,
      "queue" => 2,
      "due" => 412,
      "reps" => 6,
      "lapses" => 0
    },
    %{
      "cid" => 1506600429297,
      "nid" => 1506600417828,
      "cmod" => 1514058424,
      "nmod" => 1506600429,
      "mid" => 1482842770192,
      "tags" => "",
      "flds" => "Unnützunuseful",
      "sfld" => "unuseful",
      "did" => 1482060876072,
      "ord" => 1,
      "type" => 2,
      "queue" => 2,
      "due" => 417,
      "reps" => 13,
      "lapses" => 2
    },
    %{
      "cid" => 1506600538241,
      "nid" => 1506600526101,
      "cmod" => 1510071661,
      "nmod" => 1506600538,
      "mid" => 1482842770192,
      "tags" => "",
      "flds" => "reizento irritate (skin)",
      "sfld" => "to irritate (skin)",
      "did" => 1482060876072,
      "ord" => 0,
      "type" => 2,
      "queue" => 2,
      "due" => 392,
      "reps" => 7,
      "lapses" => 0
    },
    %{
      "cid" => 1506600538242,
      "nid" => 1506600526101,
      "cmod" => 1514507902,
      "nmod" => 1506600538,
      "mid" => 1482842770192,
      "tags" => "",
      "flds" => "reizento irritate (skin)",
      "sfld" => "to irritate (skin)",
      "did" => 1482060876072,
      "ord" => 1,
      "type" => 2,
      "queue" => 2,
      "due" => 390,
      "reps" => 28,
      "lapses" => 5
    },
  ]
  def insert_user(attrs \\ %{}) do
    changes = Enum.into attrs, @valid_user_attrs

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_collection(attrs \\ %{}) do
    changes = Enum.into attrs, @valid_collection_attrs

    %Collection{}
    |> Collection.changeset(changes)
    |> Repo.insert!
  end

  def insert_models do
    for model <- @valid_model_attrs do
      %Model{}
      |> Model.changeset(model)
      |> Repo.insert!
    end
  end

  def insert_decks do
    for deck <- @valid_deck_attrs do
      %Deck{}
      |> Deck.changeset(deck)
      |> Repo.insert!
    end
  end

  def insert_notes do
    for note <- @valid_note_attrs do
      %Note{}
      |> Note.changeset(note)
      |> Repo.insert!
    end
  end

  def size_integer(map) when is_map(map),
    do: Map.new map, fn {k, v} -> {k, size_integer(v)} end
  def size_integer(int) when not is_integer(int),
    do: int
  def size_integer(int) when int < 10_000_000_000,
    do: int
  def size_integer(int) when int >= 10_000_000_000,
      do: Integer.floor_div int, 1000
end
