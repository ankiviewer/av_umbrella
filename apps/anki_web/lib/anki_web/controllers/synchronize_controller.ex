defmodule AnkiWeb.SynchronizeController do
  use AnkiWeb, :controller

  def index(conn, _params) do
    Anki.request! "/collection"

    conn |> json(%{hello: "world"})
  end
end
