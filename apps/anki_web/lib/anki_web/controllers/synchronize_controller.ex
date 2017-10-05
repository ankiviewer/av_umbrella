defmodule AnkiWeb.SynchronizeController do
  use AnkiWeb, :controller

  alias Anki.Node

  def index(conn, _params) do
    IO.puts "Starting server ----"
    Node.start_server() |> IO.inspect
    IO.puts "------"


  end
end
