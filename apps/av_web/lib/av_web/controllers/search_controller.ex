defmodule AvWeb.SearchController do
  use AvWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def sanitize_struct(struct) when is_map(struct),
    do: Map.drop struct, [:__struct__, :__meta__, :id]
  def sanitize_struct(struct) when is_nil(struct),
    do: nil
  def sanitize_struct(struct) when is_list(struct),
    do: Enum.map struct, &sanitize_struct/1

  # TODO: add auth
  def collection(conn, _params) do
    collection = Collection |> Repo.one |> sanitize_struct
    models = Model |> Repo.all |> sanitize_struct
    decks = Deck |> Repo.all |> sanitize_struct

    cond do
      collection == nil ->
        json conn, %{payload: nil, error: "Collection not loaded"}
      models == [] ->
        json conn, %{payload: nil, error: "Models not loaded"}
      decks == [] ->
        json conn, %{payload: nil, error: "Decks not loaded"}
      true ->
        payload = %{collection: collection, models: models, decks: decks}
        json conn, %{payload: payload, error: false}
    end
  end

  def notes(conn, _params) do
    case notes = Note |> Repo.all |> sanitize_struct do
      [] ->
        json conn, %{payload: nil, error: "Notes not loaded"}
      _ ->
        json conn, %{payload: notes, error: false}
    end
  end
end
