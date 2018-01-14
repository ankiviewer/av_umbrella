defmodule AvWeb.SyncChannel do
  use Phoenix.Channel

  import Av.Anki.Helpers
  alias Av.{Anki, Repo}
  alias Anki.{Collection, Model, Deck, Note}

  def join("sync:deck", _message, socket) do
    send(self(), {:sync_deck, :start})

    {:ok, socket}
  end

  def handle_info({:sync_deck, :start}, socket) do
    push socket, "sync_msg", %{body: "Syncing Deck..."}

    coll = Av.request! "/collection"
    current_coll = Repo.one Collection

    cond do
      current_coll == nil ->
        update coll, socket
      current_coll.mod == size_integer(coll["mod"]) ->
        push socket, "sync_msg", %{body: "Deck already up to date"}
      true ->
        update coll, socket
    end

    {:noreply, socket}
  end

  def handle_info({_pid, :result, _res}, socket) do
    push socket, "sync_msg", %{body: "Synced!"}

    {:noreply, socket}
  end

  def update(coll, socket) do
    Repo.delete_all Collection

    %Collection{}
    |> Collection.changeset(coll)
    |> Repo.insert!

    Repo.delete_all Model

    for model <- Map.values(coll["models"]) do
      %Model{}
      |> Model.changeset(model)
      |> Repo.insert!
    end

    Repo.delete_all Deck

    for deck <- Map.values(coll["decks"]) do
      %Deck{}
      |> Deck.changeset(deck)
      |> Repo.insert!
    end

    Repo.delete_all Note

    notes = Av.request! "/notes"
    n = length notes

    for {note, i} <- Enum.with_index(notes) do
      push socket, "sync_msg", %{body: "Syncing Notes: #{i}/#{n}"}

      %Note{}
      |> Note.changeset(note)
      |> Repo.insert!
    end
  end

  def terminate(reason, _socket) do
    IO.puts "Leaving..."
    IO.puts reason
    :ok
  end
end
