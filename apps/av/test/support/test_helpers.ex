defmodule Av.TestHelpers do
  alias Av.{Repo, User}
  alias Av.Anki.{Collection, Model, Note, Deck}

  @valid_user_attrs %{name: "sam", password: "password"}
  @valid_collection_attrs %{
    "crt" => 1_111_111_111,
    "mod" => 1_111_111_111_111,
    "tags" => %{"hello" => 0, "world" => 0}
  }
  @valid_model_attrs [
    %{
      "name" => "Basic (and reversed card)",
      "did" => 1,
      "flds" => [
        %{"name" => "Front", "ord" => 0},
        %{"name" => "Back", "ord" => 1}
      ],
      "mod" => 1_507_832_120,
      "id" => 1_507_832_105_615
    },
    %{
      "name" => "en_de",
      "did" => 1_482_060_876_072,
      "flds" => [
        %{"name" => "English", "ord" => 0},
        %{"name" => "German", "ord" => 1},
        %{"name" => "Hint", "ord" => 2}
      ],
      "mod" => 1_498_897_458,
      "id" => 1_482_844_395_181
    },
    %{
      "name" => "de_reverse",
      "did" => 1_482_060_876_072,
      "flds" => [
        %{"name" => "German", "ord" => 0},
        %{"name" => "English", "ord" => 1},
        %{"name" => "Hint", "ord" => 2}
      ],
      "mod" => 1_514_653_350,
      "id" => 1_482_842_770_192
    }
  ]
  @valid_deck_attrs [
    %{
      "name" => "Default",
      "mod" => 1_482_840_611,
      "id" => 1
    },
    %{
      "name" => "DE",
      "mod" => 1_514_645_269,
      "id" => 1_482_060_876_072
    },
    %{
      "name" => "Thai",
      "mod" => 1_514_645_455,
      "id" => 1_503_955_755_113
    }
  ]
  @valid_note_attrs [
    %{
      "cid" => 1_506_600_429_296,
      "nid" => 1_506_600_417_828,
      "cmod" => 1_510_927_123,
      "nmod" => 1_506_600_429,
      "mid" => 1_482_842_770_192,
      "tags" => "",
      "flds" => "Unnützunuseful",
      "sfld" => "unuseful",
      "did" => 1_482_060_876_072,
      "ord" => 0,
      "type" => 2,
      "queue" => 2,
      "due" => 412,
      "reps" => 6,
      "lapses" => 0
    },
    %{
      "cid" => 1_506_600_429_297,
      "nid" => 1_506_600_417_828,
      "cmod" => 1_514_058_424,
      "nmod" => 1_506_600_429,
      "mid" => 1_482_842_770_192,
      "tags" => "",
      "flds" => "Unnützunuseful",
      "sfld" => "unuseful",
      "did" => 1_482_060_876_072,
      "ord" => 1,
      "type" => 2,
      "queue" => 2,
      "due" => 417,
      "reps" => 13,
      "lapses" => 2
    },
    %{
      "cid" => 1_506_600_538_241,
      "nid" => 1_506_600_526_101,
      "cmod" => 1_510_071_661,
      "nmod" => 1_506_600_538,
      "mid" => 1_482_842_770_192,
      "tags" => "",
      "flds" => "reizento irritate (skin)",
      "sfld" => "to irritate (skin)",
      "did" => 1_482_060_876_072,
      "ord" => 0,
      "type" => 2,
      "queue" => 2,
      "due" => 392,
      "reps" => 7,
      "lapses" => 0
    },
    %{
      "cid" => 1_506_600_538_242,
      "nid" => 1_506_600_526_101,
      "cmod" => 1_514_507_902,
      "nmod" => 1_506_600_538,
      "mid" => 1_482_842_770_192,
      "tags" => "",
      "flds" => "reizento irritate (skin)",
      "sfld" => "to irritate (skin)",
      "did" => 1_482_060_876_072,
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
