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

  def notes(conn, params) do
    case notes = Note |> Repo.all |> sanitize_struct |> Note.sanitize do
      [] ->
        json conn, %{payload: nil, error: "Notes not loaded"}
      _ ->
        notes = filterNotes notes, params
        json conn, %{payload: notes, error: ""}
    end
  end

  def parseParams(params) do
    case String.split params, "," do
      [""] -> []
      params -> Enum.map params, &String.to_integer/1
    end
  end

  def valid_tags?(_, [""]), do: true
  def valid_tags?(nil, _), do: true
  def valid_tags?(note_tags, param_tags) do
    note_tags
    |> String.trim
    |> String.split(" ")
    |> Enum.map(&String.trim/1)
    |> Enum.any?(&(&1 in param_tags))
  end

  def valid_search?(%{front: front, back: back}, search) do
    front = simplify_string(front)
    back = simplify_string(back)
    search = simplify_string(search)

    front =~ search or back =~ search
  end

  def simplify_string(str) do
    str
    |> String.downcase
    |> String.codepoints
    |> Enum.map(&char_map/1)
    |> Enum.join
  end

  def char_map(c) do
    case c do
      "ä" -> "a"
      "ö" -> "o"
      "ü" -> "u"
      "ß" -> "s"
      c -> c
    end
  end

  def parseTags(nil),
    do: [""]
  def parseTags(tags) do
    tags |> String.split(",") |> Enum.map(&String.trim/1)
  end

  def include?(head, decks, models, tags, search) do
    head.did in decks and head.mid in models and valid_tags?(head.tags, tags) and valid_search? head, search
  end

  def sanitize_search(str) do
    String.replace str, "%20", " "
  end

  def filterNotes(notes, params, acc \\ [])
  def filterNotes([], _params, acc),
    do: acc
  def filterNotes([head | tail], %{"decks" => decks, "models" => models, "search" => search, "tags" => tags} = params, acc) do
    with decks <- parseParams(decks),
         models <- parseParams(models),
         tags <- parseTags(tags),
         search <- sanitize_search(search)
    do
      if include? head, decks, models, tags, search do
        if length(acc) == 50 or tail == [] do
          acc ++ [head]
        else
          filterNotes tail, params, acc ++ [head]
        end
      else
        filterNotes tail, params, acc
      end
    end
  end

  @doc"""
  Reduces the notes list down to just 5 of each mid for test purpose
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
