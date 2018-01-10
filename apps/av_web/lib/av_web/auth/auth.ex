defmodule AvWeb.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Av.{User, Repo}
  alias AvWeb.Auth.Guardian

  def login(conn, user),
    do: Guardian.Plug.sign_in conn, user

  def login_by_name_and_pass(conn, name, given_pass) do
    user = Repo.get_by User, name: name

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn),
    do: Guardian.Plug.sign_out conn
end
