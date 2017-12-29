defmodule AvWeb.SearchControllerTest do
  use AvWeb.ConnCase

  test "GET /search", %{conn: conn} do
    conn = get conn, "/search"
    assert html_response conn, 200
  end
end
