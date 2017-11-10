defmodule AnkiTest do
  use ExUnit.Case, async: true

  test "/collection" do
    assert Anki.collection == "hi"
  end
end
