defmodule AvWeb.RulesControllerTest do
  use AvWeb.ConnCase

  test "GET /rules", %{conn: conn} do
    conn = get conn, "/rules"
    assert html_response conn, 200
  end
end
