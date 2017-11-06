defmodule Anki.HTTPoison.InMemory do
  @moduledoc false

  require Poison

  @root_url "http://localhost:4444"

  def get!(@root_url <> path) do
    case path do
      "/collection" ->
        
      "/notes" ->
    end
  end
end
