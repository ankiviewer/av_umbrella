defmodule Anki.TestHelpers do
  def sanitize(list) when is_list(list),
    do: Enum.map list, &sanitize/1

  def sanitize(struct) when is_map(struct) do
    struct
    |> Map.drop([:id, :__meta__, :__struct__, :inserted_at, :updated_at])
    |> handle_mod
    |> sort_lists
  end

  def sort_lists(list) when is_list(list),
    do: Enum.sort(list)
  def sort_lists(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      cond do
        is_list(v) -> {k, Enum.sort v}
        true -> {k, v}
      end
    end)
  end

  @doc"""
  Removes microseconds from naive_datetime
  """
  def handle_mod(map) when is_map(map) do
    Map.new map, fn {k, v} ->
      case k do
        :mod -> {k, Map.drop(v, [:microsecond])}
        _ -> {k, v}
      end
    end
  end
end
