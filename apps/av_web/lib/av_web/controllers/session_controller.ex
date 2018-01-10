defmodule AvWeb.SessionController do
  use AvWeb, :controller

  alias AvWeb.Auth

  plug :scrub_params, "session" when action in ~w(create)a
	plug :put_layout, "login.html"

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"name" => name, "password" => password}}) do
    result = Auth.login_by_name_and_pass conn, name, password

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You are now logged in!")
        |> redirect(to: home_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid name/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: home_path(conn, :index))
  end
end

