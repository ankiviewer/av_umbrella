defmodule AnkiTest do
  use ExUnit.Case, async: false

  require Poison

  test "/collection" do
    actual = "/collection"
      |> Anki.request!

    expected = "node_app/test/models.json"
      |> File.read!
      |> Poison.decode!
      |> Map.take(Map.keys actual)
      |> IO.inspect

    assert actual == expected
  end

  test "/notes" do
    actual = "/notes"
      |> Anki.request!

    expected = "node_app/test/models.json"
      |> File.read!
      |> Poison.decode!
      |> Map.fetch!("formattedNotes")

    assert actual == expected
  end
end
