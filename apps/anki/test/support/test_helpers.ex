defmodule Anki.TestHelpers do
  def sanitize(list) when is_list(list),
    do: Enum.map list, &sanitize/1

  def sanitize(struct) when is_map(struct),
    do: Map.drop struct, [:id, :__meta__, :__struct__, :inserted_at, :updated_at]
end
