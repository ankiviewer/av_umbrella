defmodule AvWeb.SyncChannel do
  use Phoenix.Channel

  alias Av.{Anki, Repo}
  alias Anki.{Collection, Model, Deck}

  def join("sync:deck", _message, socket) do
    send(self(), {:sync_deck, :start})

    {:ok, socket}
  end

  def handle_info({:sync_deck, :start}, socket) do
    push socket, "sync_msg", %{body: "Syncing Deck..."}

    coll = "/collection" |> Av.request!

    %Collection{}
    |> Collection.changeset(coll)
    # |> Repo.insert_or_update! # TODO: based on what?


    for model <- Map.values(coll["models"]) do
      %Model{}
      |> Model.changeset(model)
    end
    # |> Repo.insert_or_update!

    for deck <- Map.values(coll["decks"]) do
      %Deck{}
      |> Deck.changeset(deck)
    end

    {:noreply, socket}
  end

  def handle_info({_pid, :result, _res}, socket) do
    push socket, "sync_msg", %{body: "Synced!"}

    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    IO.puts "Leaving..."
    IO.inspect reason
    :ok
  end
end
