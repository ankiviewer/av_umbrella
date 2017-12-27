defmodule AnkiWeb.SearchControllerTest do
  use AnkiWeb.ConnCase

  test "GET /search", %{conn: conn} do
    conn = get conn, "/search"
    assert html_response conn, 200
  end
end
