defmodule Anki.Sync do
  @moduledoc false
  require Poison

  # Following mocking convention outlined here:
  # http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/
  @httpoison Application.get_env :anki, :httpoison
  @root_url "http://localhost:4444"

  def collection do
    @httpoison.get!(@root_url <> "/collection")
  end

  def notes do
    @httpoison.get!(@root_url <> "/notes")
  end
end
