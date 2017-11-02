defmodule AnkiWeb.SynchronizeController do
  use AnkiWeb, :controller

  alias Anki.Node

  def index(conn, _params) do
    Node.start_server()

    conn |> json(%{hello: "world"})
  end
end
