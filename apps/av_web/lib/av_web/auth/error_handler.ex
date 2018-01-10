defmodule AvWeb.Auth.ErrorHandler do
  import Plug.Conn
  import AvWeb.Router.Helpers

  def auth_error(conn, {type, _reason}, _opts) do
    IO.inspect type
    if type == :unauthenticated do
      conn
      |> Phoenix.Controller.put_flash(:error, "You must be signed in to access that page")
      |> Phoenix.Controller.redirect(to: session_path(conn, :new))
    else
      body = Poison.encode!(%{message: to_string(type)})
      send_resp(conn, 401, body)
    end
  end
end

