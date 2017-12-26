defmodule AnkiWeb.SettingsControllerTest do
  use AnkiWeb.ConnCase

  test "GET /settings", %{conn: conn} do
    conn = get conn, "/settings"
    assert html_response conn, 200
  end
end
