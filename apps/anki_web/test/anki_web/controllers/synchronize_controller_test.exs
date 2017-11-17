defmodule AnkiWeb.SynchronizeControllerTest do
  use AnkiWeb.ConnCase

  require Poison

  test "GET /synchronize", %{conn: conn} do
    actual = conn
      |> get(synchronize_path conn, :index)
      |> json_response(200)

    # expected = Anki.json_model()
    #   |> File.read!
    #   |> Poison.decode!
    #   |> Map.take(Map.keys actual)
    expected = %{"message" => "success"}

    assert actual == expected
  end
end
