defmodule Anki.Rule do
  @moduledoc"""
  Module for determining issues with the anki deck
  """

  @doc"""
  Each rule in the following list takes:
  - a name :: string
  - id (unique) :: integer
  - func with the following args:
    - deck :: list :: maps (notes)
    - card in question :: map

  Each of these will be run through the deck.
  If the function returns:
  - String with the issue if there are ammendments to be made
  - false if everything is fine
  """
  def list do
    [
      %{
        id: 1,
        name: "Repeated 'one' string",
        func: &rule_1/2
      }
    ]
  end

  def rule_1(deck, card) do
    Enum.any?(
      deck,
      &(&1.one == card.one and &1.anki_note_id != card.anki_note_id)
    )
  end
end
