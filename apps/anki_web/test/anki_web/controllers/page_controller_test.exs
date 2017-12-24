defmodule AnkiWeb.PageControllerTest do
  use AnkiWeb.ConnCase, async: false

  alias Anki.Collection

  setup do
    "/collection"
    |> Anki.request!
    |> Collection.format!
    |> Collection.update!

    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200)
  end
end
