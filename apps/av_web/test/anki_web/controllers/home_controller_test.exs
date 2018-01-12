defmodule AvWeb.HomeControllerTest do
  use AvWeb.ConnCase, async: false

  describe "updated_at" do
    test "without Collection" do
      conn = get build_conn(), "/api/deck"
      actual = json_response conn, 200
      expected = %{"error" => "Collection not loaded", "payload" => nil}

      assert actual == expected
    end

    test "with Collection" do
      insert_collection()

      conn = get build_conn(), "/api/deck"
      actual = json_response conn, 200
      expected = %{"error" => false, "mod" => 1111111111}

      assert actual == expected
    end
  end
end
