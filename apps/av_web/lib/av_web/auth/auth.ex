defmodule AvWeb.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import AvWeb.Auth.Guardian.Plug, only: [sign_in: 2, sign_out: 1]

  alias Av.{User, Repo}

  def login(conn, user),
    do: sign_in conn, user

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
    do: sign_out conn
end
