defmodule AvWeb.DeckController do
  use AvWeb, :controller

  def index(conn, _params) do
    case Repo.one(Collection) do
      %Collection{mod: mod} ->
        json conn, %{mod: mod}
      nil ->
        json conn, %{mod: nil}
    end
  end
end
