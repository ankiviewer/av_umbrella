defmodule AvWeb.Auth.ErrorHandler do
  import Plug.Conn
  import AvWeb.Router.Helpers
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def auth_error(conn, {type, _reason}, _opts) do
    if type == :unauthenticated do
      conn
      |> put_flash(:error, "You must be signed in to access that page")
      |> redirect(to: session_path(conn, :new))
    else
      body = Poison.encode!(%{message: to_string(type)})
      send_resp(conn, 401, body)
    end
  end
end
