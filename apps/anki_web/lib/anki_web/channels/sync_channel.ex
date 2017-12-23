defmodule AnkiWeb.SyncChannel do
  use Phoenix.Channel

  alias Anki.{Collection, Note}

  def join("sync:deck", _message, socket) do
    send(self(), {:sync_deck, :start})

    {:ok, socket}
  end

  def handle_info({:sync_deck, :start}, socket) do
    push socket, "sync_msg", %{body: "Syncing Collection..."}

    "/collection"
    |> Anki.request!
    |> Collection.format
    |> Collection.update!

    push socket, "sync_msg", %{body: "Syncing Notes..."}

    Note.delete!()

    push socket, "sync_msg", %{body: "Removing old notes..."}

    notes = Anki.request! "/notes"

    n = length notes

    for {note, i} <- Enum.with_index(notes) do
      push socket, "sync_msg", %{body: "Notes: #{i}/#{n}"}
      note
      |> Note.format!
      |> Note.insert!
    end

    {:noreply, socket}
  end

  def handle_info({_pid, :result, _res}, socket) do
    push socket, "sync_msg", %{body: "Synced!"}

    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    IO.puts "Leaving... "
    IO.inspect reason
    :ok
  end
end
