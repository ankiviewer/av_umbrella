defmodule Anki do
  @moduledoc """
  Anki keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @httpoison Application.get_env :anki, :httpoison

  def get_notes() do

  end
end
