defmodule AnkiTest do
  use ExUnit.Case, async: false

  require Poison

  test "/collection" do
    actual = "/collection"
    |> Anki.request!
    |> Poison.decode!

    expected = "node_app/test/models.json"
    |> File.read!
    |> Poison.decode!
    |> Map.take(Map.keys actual)

    assert actual == expected
  end

  test "/notes" do
    actual = "/notes"
    |> Anki.request!
    |> Poison.decode!

    expected = "node_app/test/models.json"
    |> File.read!
    |> Poison.decode!
    |> Map.fetch!("formattedNotes")

    assert actual == expected
  end
end
