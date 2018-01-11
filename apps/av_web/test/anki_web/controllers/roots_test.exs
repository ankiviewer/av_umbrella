defmodule RootsTest do
  use AvWeb.ConnCase
  alias AvWeb.Auth
  alias Av.{Repo, User}

  @with_auth [
    {"/"},
    {"/rules"},
    {"/search"},
    {"/settings"},
  ]
  @without_auth [
    {"/sessions/new"}
  ]

  setup do
    user = %User{}
    |> User.registration_changeset(%{name: "sam", password: "password"})
    |> Repo.insert!

    {:ok, conn: Auth.login(build_conn(), user)}
  end

  test "unauthorized" do
    for {root} <- @with_auth do
      conn = get build_conn(), root
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end

  test "authorized", %{conn: conn} do
    for {root} <- @with_auth do
      conn = get conn, root
      assert html_response conn, 200
    end
  end

  test "no auth" do
    for {root} <- @without_auth do
      conn = get build_conn(), root
      assert html_response conn, 200
    end
  end
end
