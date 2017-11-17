defmodule Anki.TestHelpers do
  def sanitize(struct),
    do: Map.drop struct, [:id, :__meta__, :inserted_at, :updated_at]
end
