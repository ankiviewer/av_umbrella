defmodule AnkiTest do
  use ExUnit.Case, async: false

  test "/collection" do
    assert Anki.collection == "hi"
  end

  # test "/notes" do
  #   assert Anki.notes == "hello"
  # end
end
