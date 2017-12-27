defmodule AnkiWeb.RulesControllerTest do
  use AnkiWeb.ConnCase

  test "GET /rules", %{conn: conn} do
    conn = get conn, "/rules"
    assert html_response conn, 200
  end
end
