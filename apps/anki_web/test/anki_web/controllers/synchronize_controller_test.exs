defmodule AnkiWeb.SynchronizeControllerTest do
  use AnkiWeb.ConnCase, async: false

  # require Poison

  test "GET /synchronize", %{conn: conn} do
    actual = conn
      |> post(synchronize_path conn, :create, %{"type" => "collection"})
      |> json_response(200)

    expected = %{"message" => "success"}

    assert actual == expected

    # TODO: Also test for db updating correctly
    #
    # expected = Anki.json_model()
    #   |> File.read!
    #   |> Poison.decode!
    #   |> Map.take(Map.keys actual)
  end
end
