defmodule Anki do
  @moduledoc """
  Anki keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  require Poison
  require HTTPoison
  alias Anki.Node

  @root_url "http://localhost:4444"

  def collection do
    Node.start_server()
    HTTPoison.get!(@root_url <> "/collection")
  end

  def notes do
    HTTPoison.get!(@root_url <> "/notes")
  end
end
