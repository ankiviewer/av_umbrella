defmodule AnkiWeb.SynchronizeController do
  use AnkiWeb, :controller

  def index(conn, _params) do
    _collection = Anki.request! "/collection"

    json conn, %{"message" => "success"}
  end
end
