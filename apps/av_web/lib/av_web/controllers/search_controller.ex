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
        json conn, %{payload: payload, error: ""}
    end
  end

  def notes(conn, _params) do
    case notes = Note |> Repo.all |> sanitize_struct |> Note.sanitize |> strip do
      [] ->
        json conn, %{payload: nil, error: "Notes not loaded"}
      _ ->
        json conn, %{payload: notes, error: ""}
    end
  end

  @doc"""
  Reduces the notes list down to just 5 of each mid
  """
  def strip(ns, acc \\ [])
  def strip([], acc), do: acc
  def strip([head | tail], acc) do
    acc
    |> Enum.filter(&(&1.mid == head.mid))
    |> length
    |> Kernel.==(5)
    |> case do
      true -> strip tail, acc
      false -> strip tail, acc ++ [head]
    end
  end
end
