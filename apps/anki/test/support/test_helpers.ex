defmodule Anki.TestHelpers do
  def sanitize(list) when is_list(list),
    do: Enum.map list, &sanitize/1

  def sanitize(struct) when is_map(struct) do
    struct
    |> Map.drop([:id, :__meta__, :__struct__, :inserted_at, :updated_at])
    |> handle_mod
  end

  def handle_mod(map) do
    Map.new map, fn {k, v} ->
      case k do
        :mod -> {k, remove_microseconds(v)}
        _ -> {k, v}
      end
    end
  end

  def remove_microseconds(struct),
    do: Map.drop struct, [:microsecond]
end
