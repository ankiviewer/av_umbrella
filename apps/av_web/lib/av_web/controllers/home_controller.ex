defmodule AvWeb.HomeController do
  use AvWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # TODO: add auth
  def updated_at(conn, _params) do
    case Repo.one(Collection) do
      nil ->
        json conn, %{error: "Collection not loaded", payload: nil}
      %Collection{mod: mod} ->
        json conn, %{error: false, mod: mod}
    end
  end
end
